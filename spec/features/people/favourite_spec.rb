require "rails_helper"

RSpec.describe "Favourite people", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @person = create(:person)
  end

  it "Favourite button adds person to favourite", js: true do
    visit person_path(@person)
    page.find("#person-favourite").click
    visit person_path(@person)
    expect(page).to have_css("#person-favourite.selected")
  end
end
