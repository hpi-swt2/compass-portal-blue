require 'icalendar'
require 'ice_cube'
require 'json'
require 'yaml'
require 'date'
require 'time'

class Event < ApplicationRecord
  belongs_to :room, optional: true
  validates :name, :d_start, :d_end, presence: true

  def self.ical_rule_to_ice_cube_yaml(icalendar_rrule)
    rrule_yaml = ""
    unless icalendar_rrule.nil?
      rrule_ics = "FREQ=#{icalendar_rrule.frequency}"
      rrule_ics << ";INTERVAL=#{icalendar_rrule.interval}"                   unless icalendar_rrule.interval.nil?
      rrule_ics << ";COUNT=#{icalendar_rrule.count}"                         unless icalendar_rrule.count.nil?
      rrule_ics << ";UNTIL=#{icalendar_rrule.until}"                         unless icalendar_rrule.until.nil?
      rrule_ics << ";WKST=#{icalendar_rrule.week_start}"                     unless icalendar_rrule.week_start.nil?
      rrule_ics << ";BYSECOND=#{icalendar_rrule.by_second.join(',')}"        unless icalendar_rrule.by_second.nil?
      rrule_ics << ";BYMINUTE=#{icalendar_rrule.by_minute.join(',')}"        unless icalendar_rrule.by_minute.nil?
      rrule_ics << ";BYHOUR=#{icalendar_rrule.by_hour.join(',')}"            unless icalendar_rrule.by_hour.nil?
      rrule_ics << ";BYDAY=#{icalendar_rrule.by_day.join(',')}"              unless icalendar_rrule.by_day.nil?
      rrule_ics << ";BYBYMONTHDAY=#{icalendar_rrule.by_month_day.join(',')}" unless icalendar_rrule.by_month_day.nil?
      rrule_ics << ";BYMONTH=#{icalendar_rrule.by_month.join(',')}"          unless icalendar_rrule.by_month.nil?
      rrule_ics << ";BYYEARDAY=#{icalendar_rrule.by_year_day.join(',')}"     unless icalendar_rrule.by_year_day.nil?
      rrule_yaml = IceCube::Rule.from_ical(rrule_ics).to_yaml
    end
    rrule_yaml
  end

  def self.find_room(location_string)
    room = Room.find_by(name: location_string)
    room || nil
  end

  def self.import(file)
    calendars = Icalendar::Calendar.parse(file)
    calendars.each do |calendar|
      calendar.events.each do |parse_event|
        Event.create(
          name: parse_event.summary.force_encoding("UTF-8"),
          d_start: parse_event.dtstart,
          d_end: parse_event.dtend,
          description: parse_event.description.nil? ? "" : parse_event.description.force_encoding("UTF-8"),
          recurring: ical_rule_to_ice_cube_yaml(parse_event.rrule.first),
          room: Room.find_by(name: parse_event.location.to_s)
        )
      end
    end
  end

  def self.generate_calendar_events(events, start_date, end_date)
    events.flat_map { |event| event.calendar_events(start_date, end_date) }
  end

  def start_hour_minute
    d_start.strftime('%H:%M')
  end

  def start_time
    d_start
  end

  def end_time
    d_end
  end

  def end_hour_minute
    d_end.strftime('%H:%M')
  end

  def rule
    IceCube::Rule.from_yaml(recurring) if recurring.present?
  end

  def schedule
    schedule = IceCube::Schedule.new(d_start, end_time: d_end)
    schedule.add_recurrence_rule(rule)
    schedule
  end

  def calendar_events(start_date, end_date)
    if recurring.blank?
      [self] if (start_date..end_date).cover?(d_start) || (start_date..end_date).cover?(d_end)
    else
      schedule.occurrences_between(start_date, end_date).map do |occurrence|
        Event.new(id: id, name: name, description: description, d_start: occurrence.start_time,
                  d_end: occurrence.end_time)
      end
    end
  end
end
