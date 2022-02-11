require 'rails_helper'
require 'ice_cube'
require 'time'

RSpec.describe Event, type: :model do
  it "has name, description, start_time, end_time, room, and recurrence rule" do
    event = create :event
    room = create :room

    expect(event.name).to eq('BA Mathematik III Übung')
    expect(event.description).to eq("Teaching mathematics")
    expect(event.room.name).to eq(room.name)
    expect(event.start_time).to eq("2021-10-25 13:15:00")
    expect(event.end_time).to eq("2021-10-25 14:45:00")
    expect(event.rule).to eq(IceCube::Rule.weekly.day(:monday))
  end

  it "has a room" do
    event = described_class.reflect_on_association(:room)
    expect(event.macro).to eq :belongs_to
  end

  context "without recurrence rule" do
    let(:event) { create :event, recurring: nil }

    it "returns itself in calendar_events if it is in the time frame" do
      calendar_events = event.calendar_events("2021-10-20 13:15:00", "2021-10-30 14:45:00")
      expect(calendar_events.length).to eq 1
      expect(calendar_events).to include(event)
    end

    it "returns itself in calendar_events if it intersects the time frame" do
      early_calendar_events = event.calendar_events("2021-10-20 13:15:00", "2021-10-25 14:00:00")
      late_calendar_events = event.calendar_events("2021-10-25 14:00:00", "2021-10-30 14:45:00")

      expect(early_calendar_events.length).to eq 1
      expect(early_calendar_events).to include(event)

      expect(late_calendar_events.length).to eq 1
      expect(late_calendar_events).to include(event)
    end

    it "returns nil if it does not intersect the time frame" do
      earlier_calendar_events = event.calendar_events("2021-10-20 13:15:00", "2021-10-22 14:45:00")
      later_calendar_events = event.calendar_events("2021-10-30 13:15:00", "2021-11-25 14:45:00")

      expect(earlier_calendar_events).to be_nil
      expect(later_calendar_events).to be_nil
    end
  end

  context "with recurrence rule" do
    let(:event) { create :event, recurring: IceCube::Rule.weekly.day(:monday).count(3).to_yaml }

    it "generates calendar events for all occurences in a time frame" do
      calendar_events = event.calendar_events("2021-10-20 00:00:00", "2022-01-25 00:00:00")
      expect(calendar_events.length).to eq 3
      occurence_start_times = ["2021-10-25 13:15:00 UTC", "2021-11-01 13:15:00 UTC", "2021-11-08 13:15:00 UTC"]
      occurence_end_times = ["2021-10-25 14:45:00 UTC", "2021-11-01 14:45:00 UTC", "2021-11-08 14:45:00 UTC"]

      calendar_events.zip(occurence_start_times, occurence_end_times).each do |calendar_event, start_time, end_time|
        expect(calendar_event.id).to eq event.id
        expect(calendar_event.name).to eq event.name
        expect(calendar_event.description).to eq event.description
        expect(calendar_event.room).to eq event.room
        expect(calendar_event.start_time).to eq start_time
        expect(calendar_event.end_time).to eq end_time
      end
    end
  end

  it "can return the time of the day it starts at" do
    event = create :event
    expect(event.start_hour_minute).to eq "13:15"
  end

  it "can return the time of the day it ends at" do
    event = create :event
    expect(event.end_hour_minute).to eq "14:45"
  end
end
