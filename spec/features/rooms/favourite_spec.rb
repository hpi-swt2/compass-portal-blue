require "rails_helper"

RSpec.describe "Favourite rooms", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @room = create(:room)
  end

  it "Favourite button adds room to favourite", js: true do
    visit room_path(@room)
    page.find("#room-favourite").click
    visit room_path(@room)
    expect(page).to have_css("#room-favourite.selected")
  end
end
