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

  it "Includes room" do
    visit get_favourites_path
    expect(page).to have_content(@room.name)
  end

  it "Includes building" do
    visit get_favourites_path
    expect(page).to have_content(@building.name)
  end

  it "Includes location" do
    visit get_favourites_path
    expect(page).to have_content(@location.name)
  end

  it "Includes person" do
    visit get_favourites_path
    expect(page).to have_content(@person.name)
  end

  it "Delete button unfavourites room", js: true do
    visit get_favourites_path
    page.find(".delbttn[data-favourable-type='rooms']").click
    sleep(0.5)
    visit get_favourites_path
    expect(page).not_to have_css(".delbttn[data-favourable-type='rooms']")
  end

  it "Delete button unfavourites building", js: true do
    visit get_favourites_path
    page.find(".delbttn[data-favourable-type='buildings']").click
    sleep(0.5)
    visit get_favourites_path
    expect(page).not_to have_css(".delbttn[data-favourable-type='buildings']")
  end

  it "Delete button unfavourites location", js: true do
    visit get_favourites_path
    page.find(".delbttn[data-favourable-type='locations']").click
    sleep(0.5)
    visit get_favourites_path
    expect(page).not_to have_css(".delbttn[data-favourable-type='locations']")
  end

  it "Delete button unfavourites person", js: true do
    visit get_favourites_path
    page.find(".delbttn[data-favourable-type='people']").click
    sleep(0.5)
    visit get_favourites_path
    expect(page).not_to have_css(".delbttn[data-favourable-type='people']")
  end
end
