require 'rails_helper'

RSpec.describe "welcome/index", type: :feature do

  it "has a search bar" do
    visit root_path

    expect(page).to have_field("search")
  end

  it "has a top bar with the navigator logo and a login option" do
    visit root_path
    expect(page).to have_css('.topbar-custom')
    expect(page).to have_css('.topbar-custom .navbar-brand')
    expect(page).to have_link(href: login_path)
  end

  it "has a navigation bar with a link to the map page, the search page and rooms page and icons" do
    visit root_path
    expect(page).to have_link(href: root_path)
    expect(page).to have_link(href: building_map_path)
    expect(page).to have_link(href: rooms_path)
    expect(page).to have_css('.nav-link.active i.fa-search')
    expect(page).to have_css('.nav-link:not(.active) i.fa-map')
    expect(page).to have_css('.nav-link:not(.active) i.fa-door-open')
  end

end
