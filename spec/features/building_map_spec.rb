require "rails_helper"

describe "Building Map page", type: :feature do
  it "contains a map", js: true do
    visit root_path
    find(".leaflet-container")
    expect(page).to have_css("#map")
  end

  it "highlights buildings on the map", js: true do
    visit root_path
    page.assert_selector('path.building', count: 15, wait: 5)
    expect(page).to have_css(".leaflet-interactive")
    expect(page).to have_selector("path.building", count: 15)
  end

  it "separates HPI and Uni-Potsdam buildings", js: true do
    visit root_path
    page.assert_selector('path.hpi-building', minimum: 1, wait: 5)
    expect(page).to have_selector("path.hpi-building", count: 13)
    expect(page).to have_selector("path.uni-potsdam-building", count: 2)
  end

  it "shows the name of the HPI buildings", js: true do
    visit root_path
    page.assert_selector("div.building-icon", minimum: 13, wait: 5)
    expect(page).to have_css(".leaflet-marker-pane")
    expect(page).to have_css(".leaflet-marker-icon")
    expect(page).to have_selector("div.building-icon", minimum: 13)
  end

  it "shows the pin of a building", js: true do
    building = Building.create!(
      name: 'Haus D',
      location_latitude: "52.3918793",
      location_longitude: "13.1240368"
    )
    visit "/map#{building_path(building)}"
    find(".target-pin", wait: 5)
    expect(page).to have_css(".target-pin")
  end

  it "shows the pin of a location", js: true do
    location = Location.create!(
      name: 'Test Location',
      location_latitude: "52.3918793",
      location_longitude: "13.1240368"
    )
    visit "/map#{location_path(location)}"
    find(".target-pin", wait: 5)
    expect(page).to have_css(".target-pin")
  end

  it "shows no route, if it's not requested", js: true do
    visit root_path
    expect(page).not_to have_css(".route-path-outdoor")
    expect(page).not_to have_css(".time-icon")
  end

  it "renders the map with all special features", js: true do
    visit root_path
    expect(page).to have_css("#map")
    expect(page).to have_css(".leaflet-container")
    page.assert_selector("path.building", count: 15, wait: 5)
    expect(page).to have_selector("path.hpi-building", count: 13)
    expect(page).to have_selector("div.building-icon", minimum: 13)
    expect(page).to have_selector("path.uni-potsdam-building", count: 2)
  end

  # Following tests might be inconsistent when run on GitHub Actions.

  context "with pins", inconsistent: true do
    before { skip("Tests behave inconsistently") }

    it "adds pins on click on map", js: true do
      visit root_path
      find("#map").click(x: 50, y: 50)
      expect(page).to have_css(".pin-icon1")
      find("#map").click(x: 100, y: 100)
      expect(page).to have_css(".pin-icon2")
      find("#map").click(x: 150, y: 150)
      expect(page).not_to have_css(".pin-icon1")
      expect(page).not_to have_css(".pin-icon2")
    end

    it "opens links when a pin is clicked", js: true do
      visit root_path
      find("#map").click(x: 50, y: 50)
      find("#map").click(x: 50, y: 50)
      expect(page).to have_content("Add Room")
      expect(page).to have_content("Add Building")
      expect(page).to have_content("Add Location")
      expect(page).to have_content("Delete Pin")
    end

    it "removes a pin when delete pin is clicked", js: true do
      visit root_path
      find("#map").click(x: 50, y: 50)
      expect(page).to have_css(".pin-icon1")
      find("#map").click(x: 50, y: 50)
      find("#deletepin").click
      expect(page).not_to have_css(".pin-icon1")
    end

    it "calls the new_room route when Add Room is clicked", js: true do
      sign_in(create(:user, admin: true))
      visit root_path
      find("#map").click(x: 50, y: 50)
      find("#map").click(x: 50, y: 50)
      click_on "Add Room"
      expect(page).to have_content("New Room")
    end

    it "calls the new_building route when Add Building is clicked", js: true do
      sign_in(create(:user, admin: true))
      visit root_path
      find("#map").click(x: 50, y: 50)
      find("#map").click(x: 50, y: 50)
      click_on "Add Building"
      expect(page).to have_content("New Building")
    end

    it "calls the new_location route when Add Location is clicked", js: true do
      sign_in(create(:user, admin: true))
      visit root_path
      find("#map").click(x: 50, y: 50)
      find("#map").click(x: 50, y: 50)
      click_on "Add Location"
      expect(page).to have_content("New Location")
    end
  end

  context "with route", inconsistent: true, local_only: true do
    before do
      Building.create!(
        name: 'Haus A',
        location_latitude: "52.3934534",
        location_longitude: "13.1312424"
      )
      Location.create!(
        name: 'Location 1',
        location_latitude: "52.39262",
        location_longitude: "13.12488"
      )
      visit map_path('route')
      fill_in 'start', with: 'Haus A'
      fill_in 'dest', with: 'Location 1'
      click_on 'Go'
    end

    it "shows no route, if it's not requested", js: true do
      expect(page).not_to have_css(".route-path-outdoor")
      expect(page).not_to have_css(".time-icon")
    end

    it "shows a calculated route", js: true do
      find(".route-path-outdoor", wait: 15)
      expect(page).to have_css(".route-path-outdoor")
    end

    it "shows the time of a calculated route", js: true do
      find(".time-icon", wait: 15)
      expect(page).to have_css(".time-icon")
    end
  end
end
