require "rails_helper"

RSpec.describe "Favourite buildings", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @building = create(:building)
  end

  it "Favourite button adds building to favourite", js: true do
    visit building_path(@building)
    page.find("#building-favourite").click
    visit building_path(@building)
    expect(page).to have_css("#building-favourite.selected")
  end
end
