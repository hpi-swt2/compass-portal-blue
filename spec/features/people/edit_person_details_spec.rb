require "rails_helper"

RSpec.describe "Person edit details page", type: :feature do
  before do
    @person = create :person

    @person.profile_picture.attach(
      io: File.open('app/assets/images/default-profile-picture.png'),
      filename: 'default-profile-picture.png',
      content_type: 'image/png'
    )

    sign_in(create(:user, admin: true))
  end

  it "includes profile picture input" do
    visit edit_person_path(@person)
    expect(page).to have_field 'person[profile_picture]'
  end

  it "includes profile picture view" do
    visit edit_person_path(@person)
    expect(page).to have_css "img[alt='#{@person.profile_picture.filename}']"
  end

  it "can update profile picture and show it immediately", js: true do
    filename = @person.profile_picture.filename
    @person.profile_picture.detach

    visit edit_person_path(@person)
    expect(page).not_to have_css "img[alt='#{filename}']"

    page.attach_file('person[profile_picture]', 'app/assets/images/default-profile-picture.png')

    expect(page).to have_css "img[alt='#{filename}']"

    page.find('input[type=submit][name=commit]').click

    visit edit_person_path(@person)
    expect(page).to have_css "img[alt='#{filename}']"
  end

  it "includes an input field to change the first name" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[first_name]')
  end

  it "can update first name" do
    old_first_name = @person.first_name
    new_first_name = 'Peter'

    visit edit_person_path(@person)
    fill_in 'person[first_name]', with: new_first_name
    page.find('input[type=submit][name=commit]').click

    visit edit_person_path(@person)
    expect(page).to have_field('person[first_name]', with: new_first_name)
    expect(page).not_to have_field('person[first_name]', with: old_first_name)
  end

  it "includes an input field to change the last name" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[last_name]')
  end

  it "can update last name" do
    old_last_name = @person.last_name
    new_last_name = 'Peterson'

    visit edit_person_path(@person)
    fill_in 'person[last_name]', with: new_last_name
    page.find('input[type=submit][name=commit]').click

    visit edit_person_path(@person)
    expect(page).to have_field('person[last_name]', with: new_last_name)
    expect(page).not_to have_field('person[last_name]', with: old_last_name)
  end

  it "includes an input field to change the email address" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[email]')
  end

  it "can update emails address" do
    old_email_address = @person.email
    new_email_address = 'peter@peterson.de'

    visit edit_person_path(@person)
    fill_in 'person[email]', with: new_email_address
    page.find('input[type=submit][name=commit]').click

    visit edit_person_path(@person)
    expect(page).to have_field('person[email]', with: new_email_address)
    expect(page).not_to have_field('person[email]', with: old_email_address)
  end

  it "includes an input field to change the phone number" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[phone_number]')
  end

  it "can update phone number" do
    old_phone_number = @person.phone_number
    new_phone_number = '+4933155090'

    visit edit_person_path(@person)
    fill_in 'person[phone_number]', with: new_phone_number
    page.find('input[type=submit][name=commit]').click

    visit edit_person_path(@person)
    expect(page).to have_field('person[phone_number]', with: new_phone_number)
    expect(page).not_to have_field('person[phone_number]', with: old_phone_number)
  end

  it "show phone number validation error message" do
    invalid_phone_number = 'abcd'
    visit edit_person_path(@person)
    fill_in 'person[phone_number]', with: invalid_phone_number
    page.find('input[type=submit][name=commit]').click
    expect(page).to have_text('error')

  end

  it "includes an input field to change the room where the person can be found" do
    @room = create :room
    visit edit_person_path(@person)
    expect(page).to have_select('person[room_ids][]', with_options: [@room.name])
  end

  it "can update rooms" do
    room1 = create :room
    room2 = create :room, name: "C.2.3"
    @person.rooms = [room1]
    visit edit_person_path(@person)
    select room2.name, from: 'person[room_ids][]'
    unselect room1.name, from: 'person[room_ids][]'
    page.find('input[type=submit][name=commit]').click
    visit edit_person_path(@person)
    expect(page).to have_select('person[room_ids][]', selected: [room2.name])
  end

  it "includes a select field to change the day of an openingtime" do
    @openingtime = create :openingtime
    @person.openingtimes = [@openingtime]
    visit edit_person_path(@person)
    expect(@person.openingtimes).to include(@openingtime)
    expect(page).to have_select('person[openingtimes_attributes][0][day]')
  end

end
