require "rails_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end

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

    # it "shows the pin of a target point", js: true do
    #   visit building_map_path(target: "52.393913,13.133082") # TODO: This doesn't work anymore
    #   expect(page).to have_css('.target-pin')
    # end

    it "shows no route, if it's not requested", js: true do
      visit building_map_path
      expect(page).not_to have_css(".routing-path")
      expect(page).not_to have_css(".time-icon")
    end

    context "with route" do
      before do
        visit building_map_path
        find("#nav-link-navigation").click
        fill_in 'start', with: 'Haus A'
        fill_in 'dest', with: 'Haus L'
        click_on 'Go'
        wait_for_ajax
      end

      it "shows a calculated route", js: true do
        expect(page).to have_css(".routing-path")
      end

      it "shows the time of a calculated route", js: true do
        expect(page).to have_css(".time-icon")
      end

      it "only shows one route at the time", ts: true do
        expect(page).to have_css(".routing-path", count: 1)
        fill_in 'start', with: 'Haus A'
        fill_in 'dest', with: 'Haus L'
        click_on 'Go'
        expect(page).to have_css(".routing-path", count: 1)
      end

    end
  end
end
