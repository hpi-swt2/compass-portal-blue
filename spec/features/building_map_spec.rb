require "rails_helper"

describe "Building Map page", type: :feature do
  it "contains a map" do
    visit building_map_path
    expect(page).to have_css("#map")
  end
end
