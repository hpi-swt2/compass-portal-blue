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

  it "switches to correct floor when showing a room", js: true do
    room = Room.create!(
      name: 'Test Room',
      location_latitude: "52.3918793",
      location_longitude: "13.1240368",
      floor: 2,
      building: create(:building)
    )
    visit "/map#{room_path(room)}?"
    find('.indoor-label', wait: 5, match: :first, visible: false).should have_content(/-2/)
  end

  it "shows no route, if it's not requested", js: true do
    visit root_path
    expect(page).not_to have_css(".routing-path")
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

  it "adds and removes pins on click on map", js: true do
    visit root_path
    find("#map").click(x: 50, y: 50)
    expect(page).to have_css(".pin-icon1")
    find("#map").click(x: 55, y: 55)
    expect(page).to have_css(".pin-icon2")
    find("#map").click(x: 60, y: 60)
    expect(page).not_to have_css(".pin-icon1")
    expect(page).not_to have_css(".pin-icon2")
  end

  it "removes a pin when clicked again", js: true do
    visit root_path
    find("#map").click(x: 50, y: 50)
    expect(page).to have_css(".pin-icon1")
    find("#map").click(x: 50, y: 50)
    expect(page).not_to have_css(".pin-icon1")
  end

  # Following tests might be inconsistent when run on GitHub Actions.
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
      expect(page).not_to have_css(".routing-path")
      expect(page).not_to have_css(".time-icon")
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
      fill_in 'dest', with: 'Location 1'
      click_on 'Go'
      find(".routing-path", wait: 5)
      expect(page).to have_css(".routing-path", count: 1)
    end

  end
end
