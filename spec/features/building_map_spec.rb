require "rails_helper"

describe "Building Map page", type: :feature do
  before do
    Capybara.current_driver = :selenium_chrome_headless
    Capybara.ignore_hidden_elements = false
  end

  after do
    Capybara.current_driver = :default
  end

  it "contains a map", js: true do
    visit building_map_path
    expect(page).to have_css("#map")
    expect(page).to have_css(".leaflet-container")
  end

  it "highlights builings on the map", js: true do
    visit building_map_path
    expect(page).to have_css(".leaflet-interactive")
    expect(page).to have_selector("path.leaflet-interactive", minimum: 15)
  end

  it "shows the name of the HPI buildings", js: true do
    visit building_map_path
    expect(page).to have_css(".leaflet-marker-pane")
    expect(page).to have_css(".leaflet-marker-icon")
    expect(page).to have_selector("div.leaflet-marker-icon", minimum: 13)
  end

end
