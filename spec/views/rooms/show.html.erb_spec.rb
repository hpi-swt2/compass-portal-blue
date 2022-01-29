require 'rails_helper'

RSpec.describe "rooms/show", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @room = assign(:room, Room.create!(
                            name: "Name",
                            floor: 0,
                            location_latitude: 1.5,
                            location_longitude: 3.5,
                            room_type: "seminar-room",
                            people: @people,
                            building: @building
                          ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Room type/)
    expect(rendered).to match(/Latitude/)
    expect(rendered).to match(/Longitude/)
    expect(rendered).to match(/Floor/)
    expect(rendered).to match(/People/)
  end

end
