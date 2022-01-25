# The model representing a room at HPI
class Room < ApplicationRecord
  belongs_to :building
  has_many :events
  has_and_belongs_to_many :people
  validates :name, presence: true
  validates :room_type, presence: true
  validates :floor, presence: true, numericality: { only_integer: true }

  def free?
    now = Time.now() - 1.hours
    now = now.in_time_zone(0)

    room_events = Event.where room_id: self.id
    p now

    free = true
    room_events.each do |event|
      schedule = event.schedule
      
      if schedule.occurring_at?(now)
        free = false
        break
      end
    end
    return free
  end
end
