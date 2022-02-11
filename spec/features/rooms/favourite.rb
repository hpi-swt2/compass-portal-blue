require "rails_helper"

RSpec.describe "Favourite rooms", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @room = create(:room)
  end

  it "Checkboxes change admin role", js: true do
    visit room_path(@room)
    page.click("room-favourite")
    visit room_path(@room)
    expect(page.find("#room-favourite")).to have_css("selected")
  end
end
