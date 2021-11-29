require 'rails_helper'

RSpec.describe "rooms/new", type: :view do
  before(:each) do
    assign(:room, Room.new(
      name: "MyString",
      floor: "MyString",
      room_type: "MyString",
      contact_person: "MyString"
    ))
  end

  it "renders new room form" do
    render

    assert_select "form[action=?][method=?]", rooms_path, "post" do

      assert_select "input[name=?]", "room[name]"

      assert_select "input[name=?]", "room[floor]"

      assert_select "input[name=?]", "room[room_type]"

      assert_select "input[name=?]", "room[contact_person]"
    end
  end
end
