require 'icalendar'
require 'ice_cube'
require 'json'
require 'yaml'
require 'date'
require 'time'

# the model representing an event in the calendar
class Event < ApplicationRecord
  belongs_to :room, optional: true
  validates :name, :start_time, :end_time, presence: true

  def self.import(file)
    calendars = Icalendar::Calendar.parse(file.read.force_encoding("UTF-8"))
    calendars.each do |calendar|
      calendar.events.each do |parse_event|
        create_from_icalendar(parse_event)
      end
    end
  end

  def self.generate_calendar_events(events, start_date, end_date)
    events.flat_map { |event| event.calendar_events(start_date, end_date) }
  end

  def start_hour_minute
    start_time.strftime('%H:%M')
  end

  def end_hour_minute
    end_time.strftime('%H:%M')
  end

  def rule
    IceCube::Rule.from_yaml(recurring) if recurring.present?
  end

  def schedule
    schedule = IceCube::Schedule.new(start_time, end_time: end_time)
    schedule.add_recurrence_rule(rule)
    schedule
  end

  def calendar_events(start_date, end_date)
    if recurring.blank?
      [self] if (start_date..end_date).cover?(start_time) || (start_date..end_date).cover?(end_time)
    else
      schedule.occurrences_between(start_date, end_date).map do |occurrence|
        Event.new(id: id, name: name, description: description, start_time: occurrence.start_time,
                  end_time: occurrence.end_time, room: room)
      end
    end
  end

  def self.ical_rule_to_ice_cube_yaml(rrule)
    rrule_yaml = ""
    unless rrule.nil?
      rrule_ics = "FREQ=#{rrule.frequency}"
      rrule_ics << single_parameter_ics_values(rrule)
      rrule_ics << multi_parameter_ics_values(rrule)
      rrule_yaml = IceCube::Rule.from_ical(rrule_ics).to_yaml
    end
    rrule_yaml
  end

  def self.single_parameter_ics_values(rrule)
    values = rrule.to_h.fetch_values :interval, :count, :until, :week_start
    strings = %w[INTERVAL COUNT UNTIL WKST]

    rrule_ics = ""
    values.zip(strings).each do |value, string|
      rrule_ics << ";#{string}=#{value}" unless value.nil?
    end
    rrule_ics
  end

  def self.multi_parameter_ics_values(rrule)
    values = rrule.to_h.fetch_values :by_second, :by_minute, :by_hour, :by_day, :by_month_day, :by_month, :by_year_day
    strings = %w[BYSECOND BYMINUTE BYHOUR BYDAY BYMONTHDAY BYMONTH BYYEARDAY]

    rrule_ics = ""
    values.zip(strings).each do |value, string|
      rrule_ics << ";#{string}=#{value.join(',')}" unless value.nil?
    end
    rrule_ics
  end

  def self.create_from_icalendar(event)
    create(name: event.summary,
           start_time: event.dtstart,
           end_time: event.dtend,
           description: event.description.nil? ? "" : event.description,
           recurring: ical_rule_to_ice_cube_yaml(event.rrule.first),
           room: Room.find_by(name: event.location.to_s))
  end
end
