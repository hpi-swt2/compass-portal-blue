require 'rails_helper'

RSpec.describe "rooms/edit", type: :view do
  before(:each) do
    @building = create :building
    @room = assign(:room, Room.create!(
      name: "MyString",
      floor: "MyString",
      room_type: "MyString",
      contact_person: "MyString",
      building: @building
    ))
  end

  it "renders the edit room form" do
    render

    assert_select "form[action=?][method=?]", room_path(@room), "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[floor]"

      assert_select "input[name=?]", "room[room_type]"

      assert_select "input[name=?]", "room[contact_person]"
    end
  end
end
