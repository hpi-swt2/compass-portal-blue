require 'rails_helper'
require 'time'
require 'date'

RSpec.describe "calendar/show", type: :view do
  before do
    @events = [Event.create!(name: "Test Event", description: "CG", start_time: Time.zone.now,
                             end_time: 1.hour.from_now, recurring: "", room: (create :room)),
               Event.create!(name: "Another Event", description: "PT", start_time: 1.hour.from_now,
                             end_time: 2.hours.from_now, recurring: "", room: (create :room))]

    @highlighted_event_id = @events.first.id
    @date = Time.zone.now
    @month = Time.zone.today.month
    @year = Time.zone.now.year
  end

  it "renders current month name and year" do
    render
    expect(rendered).to have_text(t("date.month_names")[Time.zone.today.month])
    expect(rendered).to have_text(Time.zone.now.year)
  end

  it "renders event start time and event name" do
    render
    expect(rendered).to have_text(@events.first.name)
    expect(rendered).to have_text(@events.first.start_hour_minute)
    expect(rendered).to have_text(@events.second.name)
    expect(rendered).to have_text(@events.second.start_hour_minute)
  end

  it "has events highlighted correctly" do
    render
    expect(rendered).to have_css(".highlighted_event", text: @events.first.name)
    expect(rendered).not_to have_css(".highlighted_event", text: @events.second.name)
  end

end
