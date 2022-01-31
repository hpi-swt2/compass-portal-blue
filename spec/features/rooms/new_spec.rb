require 'rails_helper'

describe "New rooms page", type: :feature do
  before do
    sign_in(create(:user, admin: true))
  end

  it "exists at 'new_room_path' and render withour error" do
    visit new_room_path
  end

  it "fills the coordinate fields with the params" do
    visit '/rooms/new?lat=51&long=13'

    expect(page).to have_field('room[location_latitude]', with: 51)
    expect(page).to have_field('room[location_longitude]', with: 13)
  end
end
