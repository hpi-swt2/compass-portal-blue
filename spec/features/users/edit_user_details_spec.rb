require "rails_helper"

RSpec.describe "User details page", type: :feature do
  before do
    @user = FactoryBot.create(:user)
  end

  it "is not viewable when not logged in" do
    visit edit_user_registration_path
    expect(page).to have_css('.alert-danger')
    expect(page).not_to have_current_path(edit_user_registration_path)
  end

  it "is viewable after login" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).not_to have_css('.alert-danger')
    expect(page).to have_current_path(edit_user_registration_path)
  end

  it "includes an input field to change the username which displays the current username" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field('user[username]', with: @user.username)
  end

  it "includes an input field to change the email address" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field('user[email]')
  end
end
