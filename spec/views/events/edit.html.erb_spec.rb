require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before do
    @event = assign(:event, FactoryBot.create(:event))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "textarea[name=?]", "event[recurring]"

      (1..5).each do |i|
        assert_select "select[name=?]", "event[d_start(#{i}i)]"
        assert_select "select[name=?]", "event[d_end(#{i}i)]"
      end

      assert_select "select[name=?]", "event[room_id]"
    end
  end
end
