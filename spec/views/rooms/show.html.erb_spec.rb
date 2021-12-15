require 'rails_helper'

RSpec.describe "rooms/show", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @room = assign(:room, Room.create!(
                            name: "Name",
                            floor: 0,
                            room_type: "Room Type",
                            people: @people,
                            building: @building
                          ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Floor/)
    expect(rendered).to match(/Room Type/)
  end

  it "renders a link to see the rooms building on the map" do
    render
    expect(rendered).to have_selector("a[href='#{
      building_map_path(target: "#{@room.building.location_latitude},#{
        @room.building.location_longitude}")}']")
  end

end
