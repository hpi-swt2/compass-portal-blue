require "rails_helper"

RSpec.describe "Favourite locations", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @location = create(:location)
  end

  it "Favourite button adds location to favourite", js: true do
    visit location_path(@location)
    page.find("#location-favourite").click
    visit location_path(@location)
    expect(page).to have_css("#location-favourite.selected")
  end
end
