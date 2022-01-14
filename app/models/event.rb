require 'icalendar'

class Event < ApplicationRecord
  def self.import(file)
    calendars = Icalendar::Calendar.parse(file)
    calendars.each do |calendar|
      calendar.events.each do |event|
        puts event
      end
    end    
  end
end
