# the model representing a room
class Room < ApplicationRecord
  has_and_belongs_to_many :owners, class_name: 'User', join_table: 'room_owner'
  belongs_to :building
  has_many :events, dependent: nil
  has_and_belongs_to_many :people

  include Favourable
  include Locateable

  validates :name, presence: true
  validates :floor, presence: true, numericality: { only_integer: true }

  def free?
    room_events = Event.where room: self
    room_events.each do |event|
      return false if event.schedule.occurring_at?(Time.zone.now)
    end
    true
  end

  def self.room_type_to_internal_mapping
    {
      'Lecture hall' => 'lecture-hall',
      'Pool room' => 'pool-room',
      'Seminar room' => 'seminar-room',
      'Conference room' => 'conference-room'
    }
  end

  def self.room_type_to_external_mapping
    {
      'lecture-hall' => 'Lecture hall',
      'pool-room' => 'Pool room',
      'seminar-room' => 'Seminar room',
      'conference-room' => 'Conference room'
    }
  end

  def search_description
    I18n.t('rooms.search_description', type: room_type, floor: floor, building: building.name)
  end
end
