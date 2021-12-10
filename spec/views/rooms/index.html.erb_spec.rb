require 'rails_helper'

RSpec.describe "rooms/index", type: :view do
  before do
    @building = create :building
    @users = [(create :user)]
    assign(:rooms, [
             Room.create!(
               name: "Name",
               floor: -2,
               room_type: "Room Type",
               users: @users,
               building: @building
             ),
             Room.create!(
               name: "Name",
               floor: -2,
               room_type: "Room Type",
               users: @users,
               building: @building
             )
           ])
  end

  it "renders a list of rooms" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "-2".to_s, count: 2
    assert_select "tr>td", text: "Room Type".to_s, count: 2
  end
end
