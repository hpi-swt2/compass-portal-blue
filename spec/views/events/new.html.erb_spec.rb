require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before do
    assign(:event, Event.new(
                     name: "MyString",
                     description: "MyText",
                     recurring: "MyText"
                   ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "textarea[name=?]", "event[recurring]"

      (1..5).each do |i|
        assert_select "select[name=?]", "event[start_time(#{i}i)]"
        assert_select "select[name=?]", "event[end_time(#{i}i)]"
      end

      assert_select "select[name=?]", "event[room_id]"
    end
  end
end
