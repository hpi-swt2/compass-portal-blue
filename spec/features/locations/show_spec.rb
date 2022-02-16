require 'rails_helper'

describe "Location Show Page", type: :feature do
  before do
    sign_in(create(:user, admin: true))
  end

  it "displays a locations' information" do
    @location = create :location
    @openingtime = create :openingtime, timeable: @location

    visit location_path(@location)

    expect(page).to have_text @location.name
    expect(page).to have_text @location.details
    expect(page).to have_text @location.openingtimes[0].day_as_string
    expect(page).to have_text @location.openingtimes[0].opens
    expect(page).to have_text @location.openingtimes[0].closes
  end
end
