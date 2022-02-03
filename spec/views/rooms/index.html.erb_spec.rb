require 'rails_helper'

RSpec.describe "rooms/index", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @rooms = Room.create([{ name: "Lecture hall 1",
                            floor: 0,
                            room_type: "lecture-hall",
                            location_latitude: 1.5,
                            location_longitude: 3.5 },
                          { name: "H-2.57",
                            floor: 2,
                            room_type: "seminar-room",
                            location_latitude: 4.5,
                            location_longitude: 5 }]) do |u|
      u.people = @people
      u.building = @building
    end
    @events = Event.create([{ name: "Hörsaal1 Event",
                              recurring: IceCube::Rule.daily.to_yaml,
                              start_time: 1.hour.from_now,
                              end_time: 2.hours.from_now,
                              room: @rooms[0] },
                            { name: "H.257 Event",
                              recurring: IceCube::Rule.daily.to_yaml,
                              start_time: 30.minutes.ago,
                              end_time: 30.minutes.from_now,
                              room: @rooms[1] }])
  end

  it "renders a list of rooms" do
    render
    expect(rendered).to have_text("Seminar rooms")
    expect(rendered).to have_text("H-2.57")
    expect(rendered).to have_text("Lecture halls")
    expect(rendered).to have_text("Lecture hall 1")
    expect(rendered).to have_text("Pool rooms")
    expect(rendered).to have_text("Conference rooms")
    expect(rendered).to have_text("free")
    expect(rendered).to have_text("occupied")
  end
end
