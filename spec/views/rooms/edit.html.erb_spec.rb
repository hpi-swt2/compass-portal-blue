require 'rails_helper'

RSpec.describe "rooms/edit", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @room = assign(:room, Room.create!(
                            name: "MyString",
                            floor: 0,
                            room_type: "seminar-room",
                            location_latitude: 1.5,
                            location_longitude: 3.5,
                            people: @people,
                            building: @building
                          ))
  end

  it "renders the edit room form" do
    render

    assert_select "form[action=?][method=?]", room_path(@room), "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[floor]"

      assert_select "input[name=?]", "room[location_latitude]"

      assert_select "input[name=?]", "room[location_longitude]"

      assert_select "select[name=?]", "room[room_type]"
    end
  end
end
