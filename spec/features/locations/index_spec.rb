require 'rails_helper'

describe "Paper Index page", :type => :feature do
  it "should display an HTML table with the headings 'Name', 'Details', 'Map', 'Photo'" do
    index_path = "/locations"
    visit index_path
    expect(page).to have_css 'table'
    within 'table' do
        expect(page).to have_text 'Name'
        expect(page).to have_text 'Details'
        expect(page).to have_text 'Photo'
        expect(page).to have_text 'Latitude'
        expect(page).to have_text 'Longitude'
        expect(page).to have_text 'Openingtimes'
    end
  end
  it "should contain a link to add new locations" do
    index_path = "/locations"
    visit index_path
    expect(page).to have_link 'New', href: new_location_path  
  end
end