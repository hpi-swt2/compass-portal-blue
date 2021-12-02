require "rails_helper"

describe "Building Map page", type: :feature do

  before do
    Capybara.current_driver = :selenium_chrome_headless
    Capybara.ignore_hidden_elements = false
  end

  it "contains a map", js: true do
    visit building_map_path
    expect(page).to have_css("#map")
    expect(page).to have_css(".leaflet-container")
  end

  it "highlights builings on the map", js: true do
    visit building_map_path
    expect(page).to have_css(".leaflet-interactive")
    expect(page).to have_selector("path.leaflet-interactive", count: 15)
  end
end
