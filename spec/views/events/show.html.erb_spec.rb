require 'rails_helper'
require 'ice_cube'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @start_time = Time.current
    @end_time = Time.current + 3.days
    @event = assign(:event, Event.create!(
      name: "Name",
      description: "A Description",
      d_start: @start_time,
      d_end: @end_time,
      recurring: IceCube::Rule.weekly.day(:monday).to_yaml
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/A Description/)
    expect(rendered).to match(/Weekly on Mondays/)
    expect(rendered).to match(/No Room/)
    expect(rendered).to match(@start_time.to_s)
    expect(rendered).to match(@end_time.to_s)
  end
end
