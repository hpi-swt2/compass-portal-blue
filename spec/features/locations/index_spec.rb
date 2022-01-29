require 'rails_helper'

describe "Locations Index page", type: :feature do
  it "displays an HTML table with the headings 'Name' and 'Photo'" do
    index_path = "/locations"
    visit index_path
    expect(page).to have_css 'table'
    within 'table' do
      expect(page).to have_text 'Name'
      expect(page).to have_text 'Photo'
    end
  end

  it "contains a link to add new locations" do
    index_path = "/locations"
    sign_in(create(:user, admin: true))
    visit index_path
    expect(page).to have_link 'New', href: new_location_path
  end
end
