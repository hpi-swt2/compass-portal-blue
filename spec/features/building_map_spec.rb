require "rails_helper"

describe "Building Map page", type: :feature do

  describe "layout" do
    it "indicates which view is enabled" do
      visit building_map_path
      expect(page).to have_css('.nav-link.active i.fa-map')
      expect(page).to have_css('.nav-link:not(.active) i.fa-search')
    end
  end

  describe "map" do
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

    it "highlights buildings on the map", js: true do
      visit building_map_path
      page.assert_selector('path.building', count: 15, wait: 5)
      expect(page).to have_css(".leaflet-interactive")
      expect(page).to have_selector("path.building", count: 15)
    end

    it "separates HPI and Uni-Potsdam buildings", js: true do
      visit building_map_path
      page.assert_selector('path.hpi-building', minimum: 1, wait: 5)
      expect(page).to have_selector("path.hpi-building", count: 13)
      expect(page).to have_selector("path.uni-potsdam-building", count: 2)
    end

    it "shows the name of the HPI buildings", js: true do
      visit building_map_path
      page.assert_selector("div.building-icon", minimum: 13, wait: 5)
      expect(page).to have_css(".leaflet-marker-pane")
      expect(page).to have_css(".leaflet-marker-icon")
      expect(page).to have_selector("div.building-icon", minimum: 13)
    end

    it "shows the pin of a target point", js: true do
      visit building_map_path(target: "52.393913,13.133082")
      find(".target-pin", wait: 5)
      expect(page).to have_css(".target-pin")
    end

    it "shows no route, if it's not requested", js: true do
      visit building_map_path
      expect(page).not_to have_css(".routing-path")
      expect(page).not_to have_css(".time-icon")
    end

    it "renders the map with all special features", js: true do
      visit building_map_path
      expect(page).to have_css("#map")
      expect(page).to have_css(".leaflet-container")
      page.assert_selector("path.building", count: 15, wait: 5)
      expect(page).to have_selector("path.hpi-building", count: 13)
      expect(page).to have_selector("div.building-icon", minimum: 13)
      expect(page).to have_selector("path.uni-potsdam-building", count: 2)
    end

    it "adds and removes pins on click on map", js: true do
      visit building_map_path
      find("#map").click(x: 50, y: 50)
      expect(page).to have_css(".pin-icon1")
      find("#map").click(x: 55, y: 55)
      expect(page).to have_css(".pin-icon2")
      find("#map").click(x: 60, y: 60)
      expect(page).not_to have_css(".pin-icon1")
      expect(page).not_to have_css(".pin-icon2")
    end

    it "removes a pin when clicked again", js: true do
      visit building_map_path
      find("#map").click(x: 50, y: 50)
      expect(page).to have_css(".pin-icon1")
      find("#map").click(x: 50, y: 50)
      expect(page).not_to have_css(".pin-icon1")
    end

    # Following tests might be inconsistent when run on GitHub Actions.
    context "with route", inconsistent: true, local_only: true do
      before do
        visit building_map_path
        find("#nav-link-navigation").click
        fill_in 'start', with: 'Haus A'
        fill_in 'dest', with: 'Haus L'
        click_on 'Go'
      end

      it "shows a calculated route", js: true do
        find(".routing-path", wait: 15)
        expect(page).to have_css(".routing-path")
      end

      it "shows the time of a calculated route", js: true do
        find(".time-icon", wait: 15)
        expect(page).to have_css(".time-icon")
      end

      it "only shows one route at the time", js: true do
        find(".routing-path", wait: 15)
        expect(page).to have_css(".routing-path", count: 1)
        fill_in 'start', with: 'Haus A'
        fill_in 'dest', with: 'Haus L'
        click_on 'Go'
        find(".routing-path", wait: 5)
        expect(page).to have_css(".routing-path", count: 1)
      end

    end
  end
end
