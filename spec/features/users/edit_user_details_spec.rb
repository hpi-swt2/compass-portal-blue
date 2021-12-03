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
end
