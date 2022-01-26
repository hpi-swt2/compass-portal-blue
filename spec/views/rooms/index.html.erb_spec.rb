require 'rails_helper'

RSpec.describe "rooms/index", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @rooms = Room.create([{ name: "Lecture hall 1", floor: 0, room_type: "lecture-hall" },
                          { name: "H-2.57", floor: 2, room_type: "seminar-room" }]) do |u|
      u.people = @people
      u.building = @building
    end
  end

  it "renders a list of rooms" do
    render
    expect(rendered).to have_text("Seminar Rooms")
    expect(rendered).to have_text("H.257")
    expect(rendered).to have_text("Lecture Halls")
    expect(rendered).to have_text("Hörsaal1")
    expect(rendered).to have_text("Pool Rooms")
    expect(rendered).to have_text("Conference Rooms")
  end
end
