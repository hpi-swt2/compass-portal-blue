require 'rails_helper'

RSpec.describe "rooms/new", type: :view do
  before do
    assign(:room, Room.new(
                    name: "MyString",
                    floor: -1,
                    location_latitude: 1.5,
                    location_longitude: 3.5,
                    room_type: "seminar-room"
                  ))
  end

  it "renders new room form" do
    render

    assert_select "form[action=?][method=?]", rooms_path, "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[floor]"

      assert_select "input[name=?]", "room[location_latitude]"

      assert_select "input[name=?]", "room[location_longitude]"

      assert_select "select[name=?]", "room[room_type]"
    end
  end
end
