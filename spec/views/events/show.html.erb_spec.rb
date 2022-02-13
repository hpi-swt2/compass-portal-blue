require 'rails_helper'
require 'ice_cube'

RSpec.describe "events/show", type: :view do
  before do
    @start_time = Time.zone.parse("2021-10-20 13:15:00")
    @end_time = @start_time + 3.days
    @event = assign(:event, Event.create!(
                              name: "Name",
                              description: "A Description",
                              start_time: @start_time,
                              end_time: @end_time,
                              recurring: IceCube::Rule.weekly.day(:monday).to_yaml
                            ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/A Description/)
    expect(rendered).to match(/Weekly on Mondays/)
    expect(rendered).to match(/No Room/)

    # in_time_zone is needed to convert the time to a `ActiveSupport::TimeWithZone`-object to make it comparable
    expect(rendered).to include(@start_time.in_time_zone(Time.now.zone).to_s)
    expect(rendered).to include(@end_time.in_time_zone(Time.now.zone).to_s)
  end
end
