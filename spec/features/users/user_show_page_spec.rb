require 'rails_helper'

describe "User Show Page", type: :feature do
  it "displays an users information" do
    @user_details = FactoryBot.create :user
    visit user_path(@user_details)

    expect(page).to have_text @user_details.first_name
    expect(page).to have_text @user_details.last_name
    expect(page).to have_text @user_details.email
    expect(page).to have_text @user_details.phone_number
    expect(page).to have_text @user_details.username
  end
end
