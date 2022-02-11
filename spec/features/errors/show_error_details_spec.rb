require 'rails_helper'

describe "Error Show Page", type: :feature do

  it "displays an error when not logged in and visiting a <>/new route" do
    visit new_person_path
    expect(page).to have_text "You are not authorized to access this page. Please log in or sign up to edit."

  end

  it "displays home and login links" do
    visit new_person_path
    expect(page).to have_link "Main Page"
    expect(page).to have_link "Login Page"
  end

end
