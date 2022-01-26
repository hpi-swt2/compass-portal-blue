require 'rails_helper'
require 'time'
require 'date'

RSpec.describe "rooms/calendar", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @room = assign(:room, Room.create!(
                            name: "Seminarraum 1",
                            floor: 0,
                            room_type: "Seminarraum",
                            people: @people,
                            building: @building
                          ))
    @events = [Event.create!(name: "Test Event", description: "CG", d_start: Time.zone.now,
    d_end: Time.zone.now, recurring: "", room_id: @room.id)]
    @date = Time.zone.now
    @month = Date::MONTHNAMES[Time.zone.today.month]
    @year = Time.zone.now.year
  end

  it "renders current month name and year" do
    render
    expect(rendered).to have_text(Date::MONTHNAMES[Time.Zone.today.month])
    expect(rendered).to have_text(Time.zone.now.year)
  end

  it "renders room name" do
    render
    expect(rendered).to have_text(@room.name)
  end

  it "renders event start time and event name" do
    render
    expect(rendered).to have_text(@events.first.name)
    expect(rendered).to have_text(@events.first.start_hour_minute)
  end

end
