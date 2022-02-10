require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before do
    @event = assign(:event, create(:event))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[name]"
      assert_select "textarea[name=?]", "event[description]"
      assert_select "textarea[name=?]", "event[recurring]"

      5.times do |i|
        assert_select "select[name=?]", "event[start_time(#{i + 1}i)]"
        assert_select "select[name=?]", "event[end_time(#{i + 1}i)]"
      end

      assert_select "select[name=?]", "event[room_id]"
    end
  end
end
