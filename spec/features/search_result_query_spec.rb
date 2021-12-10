require 'rails_helper'

RSpec.describe "Search result list page", type: :feature do

  before do
    @buildingABC = FactoryBot.create :building, name: "Building ABC"
    @buildingXYZ = FactoryBot.create :building, name: "Building XYZ"
    @roomABC = FactoryBot.create :room, name: "ABC-Room"
    @roomXYZ = FactoryBot.create :room, name: "XYZ-Room"
  end

  it "shows buildings matching the query" do
    visit search_results_path(query: "XY")
    expect(page).to have_text(@buildingXYZ.name)
    expect(page).to have_link(href: building_path(@buildingXYZ))

    visit search_results_path(query: "Building A")
    expect(page).to have_text(@buildingABC.name)
    expect(page).to have_link(href: building_path(@buildingABC))
  end

  it "does not show buildings not matching the query" do
    visit search_results_path(query: "XY")
    expect(page).not_to have_text(@buildingABC.name)
    expect(page).not_to have_link(href: building_path(@buildingABC))

    visit search_results_path(query: "Building A")
    expect(page).not_to have_text(@buildingXYZ.name)
    expect(page).not_to have_link(href: building_path(@buildingXYZ))
  end

  it "shows rooms matching the query" do
    visit search_results_path(query: "XY")
    expect(page).to have_text(@roomXYZ.name)
    expect(page).to have_link(href: room_path(@roomXYZ))

    visit search_results_path(query: "C-Room")
    expect(page).to have_text(@roomABC.name)
    expect(page).to have_link(href: room_path(@roomABC))
  end

  it "does not show rooms not matching the query" do
    visit search_results_path(query: "XY")
    expect(page).not_to have_text(@roomABC.name)
    expect(page).not_to have_link(href: room_path(@roomABC))

    visit search_results_path(query: "C-Room")
    expect(page).not_to have_text(@roomXYZ.name)
    expect(page).not_to have_link(href: room_path(@roomXYZ))
  end
end
