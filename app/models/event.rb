require 'icalendar'

class Event < ApplicationRecord
    belongs_to :room
    def self.import(file)
        calendars = Icalendar::Calendar.parse(file.tempfile)
        calendar = calendars.first
        event = calendar.events.first

        puts "start date-time: #{event.dtstart}"
        puts "start date-time timezone: #{event.dtstart.ical_params['tzid']}"
        puts "summary: #{event.summary}"
    end
end
