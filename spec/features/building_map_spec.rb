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
    expect(page).to have_selector("path.building", count: 15)
  end

  it "separates HPI and Uni-Potsdam buildings" do
    visit building_map_path
    expect(page).to have_selector("path.hpi-building", count: 13)
    expect(page).to have_selector("path.uni-potsdam-building", count: 2)
  end

  it "shows the name of the HPI buildings", js: true do
    visit building_map_path
    expect(page).to have_css(".leaflet-marker-pane")
    expect(page).to have_css(".leaflet-marker-icon")
    expect(page).to have_selector("div.building-icon", minimum: 13)
  end

  context "with route" do
    it "shows a calculated route", js: true do
      visit building_map_path(start: "52.393913,13.133082", dest: "52.393861,13.129606")
      expect(page).to have_css(".routing-path")
    end

    it "shows no route, if it's not requested", js: true do
      visit building_map_path
      expect(page).not_to have_css(".routing-path")
      expect(page).not_to have_css(".time-icon")
    end

    it "shows no route, if not all necessary parameters are provided", js: true do
      visit building_map_path(start: "52.393913,13.133082")
      expect(page).not_to have_css(".routing-path")
      expect(page).not_to have_css(".time-icon")
    end

    it "shows the time of a calculated route", js: true do
      visit building_map_path(start: "52.393913,13.133082", dest: "52.393861,13.129606")
      expect(page).to have_css(".time-icon")
    end
  end

end
