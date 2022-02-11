require "rails_helper"

RSpec.describe "Favourite rooms list", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @room = create(:room)
    @user.favourites << @room
  end

  it "Delete button unfavourites room" do
    visit get_favourite_rooms_path(@room)
    page.find(".delbttn").click
    visit get_favourite_rooms_path(@room)
    expect(page).not_to have_css('.delbttn')
  end
end
