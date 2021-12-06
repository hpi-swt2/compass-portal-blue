require "rails_helper"

RSpec.describe "User details", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  it "are not viewable when not logged in" do
    visit edit_user_registration_path
    expect(page).to have_css('.alert-danger')
    expect(page).not_to have_current_path(edit_user_registration_path)
  end

  it "are viewable after login" do
    sign_in user
    visit edit_user_registration_path
    expect(page).not_to have_css('.alert-danger')
    expect(page).to have_current_path(edit_user_registration_path)
  end

  it "includes an input field to change the username which displays the current username" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_field('user[username]', with: user.username)
  end

  it "includes an input field to change the first name" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_field('user[first_name]')
  end

  it "includes an input field to change the last name" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_field('user[last_name]')
  end

  it "includes an input field to change the email address" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_field('user[email]')
  end

  it "includes an input field to change the phone number" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_field('user[phone_number]')
  end

  it "includes an input field to change the room where the person can be found" do
    @room = create :room
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_select('user[rooms][]', with_options: [@room.name])
  end

end
