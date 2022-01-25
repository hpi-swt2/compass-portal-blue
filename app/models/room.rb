# The model representing a room at HPI
class Room < ApplicationRecord
  belongs_to :building
  has_many :events, dependent: :destroy 
  has_and_belongs_to_many :people
  validates :name, presence: true
  validates :room_type, presence: true
  validates :floor, presence: true, numericality: { only_integer: true }

  def free?
    room_events = Event.where room: self
    room_events.each do |event|
      return false if event.schedule.occurring_at?(Time.zone.now)
    end
    true
  end
end
