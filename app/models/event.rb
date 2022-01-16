require 'icalendar'
require 'json'

class Event < ApplicationRecord
  def self.import(file)
    calendars = Icalendar::Calendar.parse(file)
    calendars.each do |calendar|
      calendar.events.each do |event|
        Event.create(
          name:         event.summary.force_encoding("UTF-8"),
          d_start:      event.dtstart,
          d_end:        event.dtend,
          description:  event.description.force_encoding("UTF-8"),
          recurring:    event.rrule.to_json
        )
      end
    end    
  end
end
