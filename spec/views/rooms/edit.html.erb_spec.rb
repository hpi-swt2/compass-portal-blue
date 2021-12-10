require 'rails_helper'

RSpec.describe "rooms/edit", type: :view do
  before do
    @building = create :building
    @users = [(create :user)]
    @room = assign(:room, Room.create!(
                            name: "MyString",
                            floor: 0,
                            room_type: "MyString",
                            users: @users,
                            building: @building
                          ))
  end

  it "renders the edit room form" do
    render

    assert_select "form[action=?][method=?]", room_path(@room), "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[floor]"

      assert_select "input[name=?]", "room[room_type]"
    end
  end
end
