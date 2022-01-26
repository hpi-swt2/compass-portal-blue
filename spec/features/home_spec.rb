require 'rails_helper'

RSpec.describe "welcome/index", type: :feature do

  it "has a search bar" do
    visit root_path

    expect(page).to have_field("search")
  end

  it "has a top bar with a login option" do
    visit root_path
    expect(page).to have_css('.topbar-custom')
    expect(page).to have_link(href: login_path)
  end

end
