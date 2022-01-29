# the model representing a room
class Room < ApplicationRecord
  has_and_belongs_to_many :owners, class_name: 'User', join_table: 'room_owner'
  belongs_to :building
  has_and_belongs_to_many :people
  validates :name, presence: true
  validates :floor, presence: true, numericality: { only_integer: true }

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
end
