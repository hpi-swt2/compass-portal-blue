require 'rails_helper'

describe "location edit page", type: :feature do
  it "should exist at 'edit_author_path' and render without error" do
    location = FactoryBot.create :location
    visit edit_location_url(location)
    page.fill_in 'location[name]', with: 'Updated_name'
    page.fill_in 'location[details]', with: 'Updated_details'
    #page.fill_in 'location[location_latitude]', with: 14.0
    #page.fill_in 'location[location_longitude]', with: 20.0
    find('input[type="submit"]').click
    location.reload
    Location.exists?(:name => 'Updated_name', :details => 'Updated_details')
  end
end
