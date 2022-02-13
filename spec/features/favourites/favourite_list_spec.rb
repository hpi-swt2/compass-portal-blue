require "rails_helper"

RSpec.describe "Favourites list", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @room = create(:room)
    @room.favourited_by << @user
    @building = create(:building)
    @building.favourited_by << @user
    @location = create(:location)
    @location.favourited_by << @user
    @person = create(:person)
    @person.favourited_by << @user
  end

  it "Delete button unfavourites room", js: true do
    visit get_favourites_path(@room)
    page.find(".delbttn[data-favourable-type='rooms']").click
    visit get_favourite_rooms_path(@room)
    expect(page).not_to have_css(".delbttn[data-favourable-type='rooms']")
  end

  it "Delete button unfavourites building", js: true do
    visit get_favourites_path(@building)
    page.find(".delbttn[data-favourable-type='buildings']").click
    visit get_favourite_buildings_path(@building)
    expect(page).not_to have_css(".delbttn[data-favourable-type='buildings']")
  end

  it "Delete button unfavourites location", js: true do
    visit get_favourites_path(@location)
    page.find(".delbttn[data-favourable-type='locations']").click
    visit get_favourite_locations_path(@location)
    expect(page).not_to have_css(".delbttn[data-favourable-type='locations']")
  end

  it "Delete button unfavourites person", js: true do
    visit get_favourites_path(@person)
    page.find(".delbttn[data-favourable-type='people']").click
    visit get_favourite_people_path(@person)
    expect(page).not_to have_css(".delbttn[data-favourable-type='people']")
  end
end
