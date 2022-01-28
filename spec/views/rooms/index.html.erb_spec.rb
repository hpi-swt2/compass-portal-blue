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
  end

  it "renders a list of rooms" do
    render
    assert_select "tr>th", text: "Seminar rooms:".to_s, count: 1
    assert_select "tr>td", text: "H-2.57".to_s, count: 1
    assert_select "tr>th", text: "Lecture halls:".to_s, count: 1
    assert_select "tr>td", text: "Lecture hall 1".to_s, count: 1
    assert_select "tr>th", text: "Pool rooms:".to_s, count: 1
    assert_select "tr>th", text: "Conference rooms:".to_s, count: 1
  end
end
