require "rails_helper"

describe "User without person details page", type: :feature do
  before do
    @user = create(:user)
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

  it "includes a link-button to add a new person" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_link 'Add new person', href: new_person_path
  end

  it "includes a link-button to add a new location" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_link 'Add new location', href: new_location_path
  end

  it "includes a link-button to add a new room" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_link 'Add new room', href: new_room_path
  end

  it "includes a link-button to add a new building" do
    sign_in @user
    visit edit_user_registration_path
    expect(page).to have_link 'Add new building', href: new_building_path
  end

end

describe "User with person details page", type: :feature do
  before do
    @personuser = create(:user)
    @personuser.person = create(:person)

    @personuser.person.profile_picture.attach(
      io: File.open('app/assets/images/default-profile-picture.png'),
      filename: 'default-profile-picture.png',
      content_type: 'image/png'
    )
  end

  it "includes profile picture input" do
    visit edit_user_registration_path(@personuser)
    expect(page).to have_field 'person[profile_picture]'
  end

  it "includes profile picture view" do
    visit edit_person_path(@personuser)
    expect(page).to have_css "img[alt='#{@personuser.person.profile_picture.filename}']"
  end

  it "can update profile picture" do
    filename = @personuser.person.profile_picture.filename
    @personuser.person.profile_picture.detach

    visit edit_user_registration_path(@personuser)
    expect(page).not_to have_css "img[alt='#{filename}']"

    page.attach_file('person[profile_picture]', 'app/assets/images/default-profile-picture.png')
    page.find('input[type=submit][name=commit]').click

    visit edit_user_registration_path(@personuser)
    expect(page).to have_css "img[alt='#{filename}']"
  end

  it "includes an input field to change the first name" do
    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[first_name]')
  end

  it "can update first name" do
    old_first_name = @personuser.person.first_name
    new_first_name = 'Peter'

    visit edit_user_registration_path(@personuser)
    fill_in 'person[first_name]', with: new_first_name
    page.find('input[type=submit][name=commit]').click

    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[first_name]', with: new_first_name)
    expect(page).not_to have_field('person[first_name]', with: old_first_name)
  end

  it "includes an input field to change the last name" do
    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[last_name]')
  end

  it "can update last name" do
    old_last_name = @personuser.person.last_name
    new_last_name = 'Peterson'

    visit edit_user_registration_path(@personuser)
    fill_in 'person[last_name]', with: new_last_name
    page.find('input[type=submit][name=commit]').click

    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[last_name]', with: new_last_name)
    expect(page).not_to have_field('person[last_name]', with: old_last_name)
  end

  it "includes an input field to change the email address" do
    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[email]')
  end

  it "can update emails address" do
    old_email_address = @personuser.email
    new_email_address = 'peter@peterson.de'

    visit edit_user_registration_path(@personuser)
    fill_in 'person[email]', with: new_email_address
    page.find('input[type=submit][name=commit]').click

    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[email]', with: new_email_address)
    expect(page).not_to have_field('person[email]', with: old_email_address)
  end

  it "includes an input field to change the phone number" do
    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[phone_number]')
  end

  it "can update phone number" do
    old_phone_number = @personuser.phone_number
    new_phone_number = '+4933155090'

    visit edit_user_registration_path(@personuser)
    fill_in 'person[phone_number]', with: new_phone_number
    page.find('input[type=submit][name=commit]').click

    visit edit_user_registration_path(@personuser)
    expect(page).to have_field('person[phone_number]', with: new_phone_number)
    expect(page).not_to have_field('person[phone_number]', with: old_phone_number)
  end

  it "show phone number validation error message" do
    invalid_phone_number = 'abcd'
    visit edit_user_registration_path(@personuser)
    fill_in 'person[phone_number]', with: invalid_phone_number
    page.find('input[type=submit][name=commit]').click
    expect(page).to have_text('error')

  end

  it "includes an input field to change the room where the person can be found" do
    @room = create :room
    visit edit_user_registration_path(@personuser)
    expect(page).to have_select('person[room_ids][]', with_options: [@room.name])
  end

  it "can update rooms" do
    room1 = create :room
    room2 = create :room, name: "C.2.3"
    @personuser.rooms = [room1]
    visit edit_user_registration_path(@personuser)
    select room2.name, from: 'person[room_ids][]'
    unselect room1.name, from: 'person[room_ids][]'
    page.find('input[type=submit][name=commit]').click
    visit edit_user_registration_path(@personuser)
    expect(page).to have_select('person[room_ids][]', selected: [room2.name])
  end

  it "includes a select field to change the day of an openingtime" do
    @openingtime = create :openingtime
    @personuser.openingtimes = [@openingtime]
    visit edit_user_registration_path(@personuser)
    expect(@personuser.openingtimes).to include(@openingtime)
    expect(page).to have_select('person[openingtimes_attributes][0][day]')
  end

end