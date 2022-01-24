require 'rails_helper'
require 'ice_cube'

RSpec.describe "events/index", type: :view do
  before(:each) do

    @room = create :room
    @room.name = "A1.1"
    @start_time = Time.current
    @end_time = Time.current + 3.days
    assign(:events, [
      Event.create!(
        name: "Name",
        description: "A Description",
        d_start: @start_time,
        d_end: @end_time,
        recurring: ""
      ),
      Event.create!(
        name: "Name",
        description: "A Description",
        recurring: IceCube::Rule.weekly.day(:monday).to_yaml,
        d_start: @start_time,
        d_end: @end_time,
        room: @room
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "A Description".to_s, count: 2
    assert_select "tr>td", text: "No Room".to_s, count: 1
    assert_select "tr>td", text: @start_time.to_s, count: 2
    assert_select "tr>td", text: @end_time.to_s, count: 2
    assert_select "tr>td", text: "Weekly on Mondays".to_s, count: 1
    assert_select "tr>td", text: "A1.1".to_s, count: 1
  end
end
