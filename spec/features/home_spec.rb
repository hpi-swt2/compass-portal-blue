require 'rails_helper'

RSpec.describe "welcome/index", type: :feature do

  it "has a search bar" do
    visit root_path

    expect(page).to have_field("search")
  end
end
