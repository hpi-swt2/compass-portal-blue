require 'rails_helper'

RSpec.describe "rooms/new", type: :view do
  before do
    assign(:room, Room.new(
                    name: "MyString",
                    floor: -1,
                    room_type: "seminar-room"
                  ))
  end

  it "renders new room form" do
    render

    assert_select "form[action=?][method=?]", rooms_path, "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[floor]"

      assert_select "select[name=?]", "room[room_type]"
    end
  end
end
