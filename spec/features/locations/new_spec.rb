require 'rails_helper'

describe "New location page", type: :feature do

  it "redirects to the login page" do
    visit new_location_path
    expect(page).to have_content('You are not authorized to access this page.')
    expect(page).to have_content('Login Page')
  end

  describe "when logged in" do
    before do
      sign_in(create(:user, admin: true))
    end

    it "exists at 'new_location_path' and render withour error" do
      visit new_location_path
    end

    it "has text inputs for an location's name, details, photo, latitude, longitude and opening times" do
      visit new_location_path

      expect(page).to have_field('location[name]')
      expect(page).to have_field('location[details]')
      expect(page).to have_field('location[location_photo]')
      expect(page).to have_field('location[location_latitude]')
      expect(page).to have_field('location[location_longitude]')
    end

    it "has a form which creates database entries after filling out" do
      visit new_location_path
      page.fill_in 'location[name]', with: 'test_name'
      page.fill_in 'location[details]', with: 'test_details'
      page.fill_in 'location[location_latitude]', with: 10.0
      page.fill_in 'location[location_longitude]', with: 10.0
      find('input[type="submit"]').click
      expect(Location.where(name: 'test_name', details: 'test_details', location_latitude: 10.0,
                            location_longitude: 10.0)).to exist
    end

    it "fills the coordinate fields with the params" do
      visit '/locations/new?lat=51&long=13'

      expect(page).to have_field('location[location_latitude]', with: 51)
      expect(page).to have_field('location[location_longitude]', with: 13)
    end
  end
end
