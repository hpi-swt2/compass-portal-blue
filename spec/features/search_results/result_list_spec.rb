require 'rails_helper'

RSpec.describe "Search result list page", type: :feature do

  before do
    @building = FactoryBot.create :building
    @room = FactoryBot.create :room
  end

  it "displays found buildings" do
    visit search_results_path
    expect(page).to have_text(@building.name)
    expect(page).to have_link(href: building_path(@building))
  end

  it "displays found rooms" do
    visit search_results_path
    expect(page).to have_text(@room.name)
    expect(page).to have_link(href: room_path(@room))
  end
end
