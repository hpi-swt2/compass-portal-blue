require 'rails_helper'

RSpec.describe "rooms/index", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @rooms = Room.create([{ name: "Hörsaal1", floor: 0, room_type: "Hörsaal" },
                          { name: "H.257", floor: 2, room_type: "Seminarraum" }]) do |u|
      u.people = @people
      u.building = @building
    end
    @events = Event.create([{ name: "Hörsaal1 Event",
                              recurring: "---\n:validations: {}\n:rule_type: IceCube::DailyRule\n:interval: 1\n",
                              d_start: 1.hour.from_now,
                              d_end: 2.hours.from_now,
                              room: @rooms[0] },
                            { name: "H.257 Event",
                              recurring: "---\n:validations: {}\n:rule_type: IceCube::DailyRule\n:interval: 1\n",
                              d_start: 30.minutes.ago,
                              d_end: 30.minutes.from_now,
                              room: @rooms[1] }])
  end

  it "renders a list of rooms" do
    render
    expect(rendered).to have_text("Seminar Rooms")
    expect(rendered).to have_text("H.257")
    expect(rendered).to have_text("Lecture Halls")
    expect(rendered).to have_text("Hörsaal1")
    expect(rendered).to have_text("Pool Rooms")
    expect(rendered).to have_text("Conference Rooms")
    expect(rendered).to have_text("free")
    expect(rendered).to have_text("occupied")
  end
end
