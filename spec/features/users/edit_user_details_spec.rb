require "rails_helper"

RSpec.describe "User details page", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @user.profile_picture.attach(
      io: File.open('app/assets/images/default-profile-picture.png'),
      filename: 'default-profile-picture.png',
      content_type: 'image/png'
    )
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

  it "includes profile picture input" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field 'user[profile_picture]'
  end

  it "includes profile picture view" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_css "img[alt='#{@user.profile_picture.filename}']"
  end

  it "can update profile picture" do
    filename = @user.profile_picture.filename
    @user.profile_picture.detach

    sign_in @user
    visit edit_user_registration_path
    expect(page).not_to have_css "img[alt='#{filename}']"

    page.attach_file('user[profile_picture]', 'app/assets/images/default-profile-picture.png')
    page.find('input[type=submit][name=commit]').click

    visit edit_user_registration_path
    expect(page).to have_css "img[alt='#{filename}']"
  end

  it "includes an input field to change the username which displays the current username" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field('user[username]', with: @user.username)
  end

  it "includes an input field to change the first name" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field('user[first_name]')
  end

  it "includes an input field to change the last name" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field('user[last_name]')
  end

  it "includes an input field to change the email address" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field('user[email]')
  end

  it "includes an input field to change the phone number" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_field('user[phone_number]')
  end

  it "includes an input field to change the room where the person can be found" do
    @room = create :room
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_select('user[rooms][]', with_options: [@room.name])
  end
end
