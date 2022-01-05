require 'rails_helper'

describe "Location Show Page", type: :feature do
  it "displays a locations' information" do
    @location = FactoryBot.create :location
    @openingtime = FactoryBot.create(:openingtime, timeable: @location)

    visit location_path(@location)

    expect(page).to have_text @location.name
    expect(page).to have_text @location.details
    expect(page).to have_text @location.openingtimes[0].day_as_string
    expect(page).to have_text @location.openingtimes[0].opens
    expect(page).to have_text @location.openingtimes[0].closes
  end
end
