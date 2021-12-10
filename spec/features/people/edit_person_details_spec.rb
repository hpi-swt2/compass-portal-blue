require "rails_helper"

RSpec.describe "Person details page", type: :feature do
  before do
    @person = FactoryBot.create(:person)

    @person.profile_picture.attach(
      io: File.open('app/assets/images/default-profile-picture.png'),
      filename: 'default-profile-picture.png',
      content_type: 'image/png'
    )
  end

  it "includes profile picture input" do
    visit edit_person_path(@person)
    expect(page).to have_field 'person[profile_picture]'
  end

  it "includes profile picture view" do
    visit edit_person_path(@person)
    expect(page).to have_css "img[alt='#{@person.profile_picture.filename}']"
  end

  it "can update profile picture" do
    filename = @person.profile_picture.filename
    @person.profile_picture.detach

    visit edit_person_path(@person)
    expect(page).not_to have_css "img[alt='#{filename}']"

    page.attach_file('person[profile_picture]', 'app/assets/images/default-profile-picture.png')
    page.find('input[type=submit][name=commit]').click

    visit edit_person_path(@person)
    expect(page).to have_css "img[alt='#{filename}']"
  end

  it "includes an input field to change the first name" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[first_name]')
  end

  it "includes an input field to change the last name" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[last_name]')
  end

  it "includes an input field to change the email address" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[email]')
  end

  it "includes an input field to change the phone number" do
    visit edit_person_path(@person)
    expect(page).to have_field('person[phone_number]')
  end

  it "includes an input field to change the room where the person can be found" do
    @room = create :room
    visit edit_person_path(@person)
    expect(page).to have_select('person[rooms][]', with_options: [@room.name])
  end
end
