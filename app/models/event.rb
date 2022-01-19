require 'icalendar'
require 'ice_cube'
require 'json'
require 'yaml'
require 'date'

class Event < ApplicationRecord

  def self.import(file)
    calendars = Icalendar::Calendar.parse(file)
    calendars.each do |calendar|
      calendar.events.each do |parse_event|
        rrule_hash = ""
        icalendar_rrule = parse_event.rrule.first
        if not icalendar_rrule.nil? then
          rrule_ics = "FREQ=#{icalendar_rrule.frequency}"
          rrule_ics << ";INTERVAL=#{icalendar_rrule.interval}"                   if !icalendar_rrule.interval.nil?
          rrule_ics << ";COUNT=#{icalendar_rrule.count}"                         if !icalendar_rrule.count.nil?
          rrule_ics << ";UNTIL=#{icalendar_rrule.until}"                         if !icalendar_rrule.until.nil?
          rrule_ics << ";WKST=#{icalendar_rrule.week_start}"                     if !icalendar_rrule.week_start.nil?
          rrule_ics << ";BYSECOND=#{icalendar_rrule.by_second.join(",")}"        if !icalendar_rrule.by_second.nil?
          rrule_ics << ";BYMINUTE=#{icalendar_rrule.by_minute.join(",")}"        if !icalendar_rrule.by_minute.nil?
          rrule_ics << ";BYHOUR=#{icalendar_rrule.by_hour.join(",")}"            if !icalendar_rrule.by_hour.nil?
          rrule_ics << ";BYDAY=#{icalendar_rrule.by_day.join(",")}"              if !icalendar_rrule.by_day.nil?
          rrule_ics << ";BYBYMONTHDAY=#{icalendar_rrule.by_month_day.join(",")}" if !icalendar_rrule.by_month_day.nil?
          rrule_ics << ";BYMONTH=#{icalendar_rrule.by_month.join(",")}"          if !icalendar_rrule.by_month.nil?
          rrule_ics << ";BYYEARDAY=#{icalendar_rrule.by_year_day.join(",")}"     if !icalendar_rrule.by_year_day.nil?

          rrule_hash = IceCube::Rule.from_ical(rrule_ics).to_hash
        end

        Event.create(
          name:         parse_event.summary.force_encoding("UTF-8"),
          d_start:      parse_event.dtstart,
          d_end:        parse_event.dtend,
          description:  (parse_event.description.nil?) ? ""
                        : parse_event.description.force_encoding("UTF-8"),
          recurring:    rrule_hash
          #parse_event.rrule.empty? ? "" : parse_event.rrule.to_yaml
        )
        if not parse_event.rrule.first.nil? then
          puts "HIEEEEEEEEEEER"
          puts parse_event.rrule.first.frequency
          puts parse_event.rrule.first
        end
      end
    end
  end
  
  def calendar_events(start)
    #puts "REGEL:"
    #rule = IceCube::Rule.daily(2).day_of_week(tuesday: [1, -1], wednesday: [2])
    #puts rule.to_yaml
    if recurring.empty? then
      [self]
    else
      
    end
  end
end