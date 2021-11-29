require 'rails_helper'

RSpec.describe "rooms/index", type: :view do
  before do
    @building = create :building
    assign(:rooms, [
             Room.create!(
               name: "Name",
               floor: "Floor",
               room_type: "Room Type",
               contact_person: "Contact Person",
               building: @building
             ),
             Room.create!(
               name: "Name",
               floor: "Floor",
               room_type: "Room Type",
               contact_person: "Contact Person",
               building: @building
             )
           ])
  end

  it "renders a list of rooms" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Floor".to_s, count: 2
    assert_select "tr>td", text: "Room Type".to_s, count: 2
    assert_select "tr>td", text: "Contact Person".to_s, count: 2
  end
end
