require 'rails_helper'

describe "New buildings page", type: :feature do

  it "redirects to the login page" do
    visit new_building_path
    expect(page).to have_content('You are not authorized to access this page.')
    expect(page).to have_content('Log In')
  end

  describe "when logged in" do
    before do
      sign_in(create(:user, admin: true))
    end

    it "exists at 'new_location_path' and render withour error" do
      visit new_building_path
    end

    it "fills the coordinate fields with the params" do
      visit '/buildings/new?lat=51&long=13'

      expect(page).to have_field('building[location_latitude]', with: 51)
      expect(page).to have_field('building[location_longitude]', with: 13)
    end
  end
end
