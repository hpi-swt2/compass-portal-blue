require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
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

      for i in 1..5 do
        assert_select "select[name=?]", "event[d_start(#{i}i)]"
        assert_select "select[name=?]", "event[d_end(#{i}i)]"
      end

      assert_select "select[name=?]", "event[room]"
    end
  end
end
