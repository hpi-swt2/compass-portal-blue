require "rails_helper"

describe "User Edit Page", type: :feature do
  describe "without person details edit page part", type: :feature do
    before do
      @user = create(:user)
    end

    it "is not viewable when not logged in" do
      visit edit_user_registration_path
      expect(page).to have_css('.alert-danger')
      expect(page).not_to have_current_path(edit_user_registration_path(locale: I18n.locale))
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
      expect(page).to have_link 'Add new Person', href: new_person_path(locale: I18n.locale)
    end

    it "includes a link-button to add a new Location" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_link 'Add new Location', href: new_location_path(locale: I18n.locale)
    end

    it "includes a link-button to add a new room" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_link 'Add new Room', href: new_room_path(locale: I18n.locale)
    end

    it "includes a link-button to add a new building" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_link 'Add new Building', href: new_building_path(locale: I18n.locale)
    end
  end

  describe "with person details edit page part", type: :feature do
    before do
      @user = create(:user)

      @user.person.profile_picture.attach(
        io: File.open('app/assets/images/default-profile-picture.png'),
        filename: 'default-profile-picture.png',
        content_type: 'image/png'
      )
    end

    it "includes profile picture input" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_field 'user[person_attributes][profile_picture]'
    end

    it "includes profile picture view" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_css "img[alt='#{@user.person.profile_picture.filename}']"
    end

    it "can update profile picture and show it immediately", js: true do
      sign_in @user
      filename = @user.person.profile_picture.filename
      @user.person.profile_picture.detach

      visit edit_user_registration_path
      expect(page).not_to have_css "img[alt='#{filename}']"

      page.attach_file('user[person_attributes][profile_picture]', 'app/assets/images/default-profile-picture.png')

      expect(page).to have_css "img[alt='#{filename}']"

      page.find('#update-user-account').click

      visit edit_user_registration_path
      expect(page).to have_css "img[alt='#{filename}']"
    end

    it "includes an input field to change the first name" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][first_name]')
    end

    it "can update first name" do
      sign_in @user
      old_first_name = @user.person.first_name
      new_first_name = 'Peter'

      visit edit_user_registration_path
      fill_in 'user[person_attributes][first_name]', with: new_first_name
      page.find('#update-user-account').click

      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][first_name]', with: new_first_name)
      expect(page).not_to have_field('user[person_attributes][first_name]', with: old_first_name)
    end

    it "includes an input field to change the last name" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][last_name]')
    end

    it "can update last name" do
      sign_in @user
      old_last_name = @user.person.last_name
      new_last_name = 'Peterson'

      visit edit_user_registration_path
      fill_in 'user[person_attributes][last_name]', with: new_last_name
      page.find('#update-user-account').click

      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][last_name]', with: new_last_name)
      expect(page).not_to have_field('user[person_attributes][last_name]', with: old_last_name)
    end

    it "includes an input field to change the email address" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][email]')
    end

    it "can update emails address" do
      sign_in @user
      old_email_address = @user.email
      new_email_address = 'peter@peterson.de'

      visit edit_user_registration_path
      fill_in 'user[person_attributes][email]', with: new_email_address
      page.find('#update-user-account').click

      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][email]', with: new_email_address)
      expect(page).not_to have_field('user[person_attributes][email]', with: old_email_address)
    end

    it "includes an input field to change the phone number" do
      sign_in @user
      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][phone_number]')
    end

    it "can update phone number" do
      sign_in @user
      old_phone_number = @user.person.phone_number
      new_phone_number = '+4933155090'

      visit edit_user_registration_path
      fill_in 'user[person_attributes][phone_number]', with: new_phone_number
      page.find('#update-user-account').click

      visit edit_user_registration_path
      expect(page).to have_field('user[person_attributes][phone_number]', with: new_phone_number)
      expect(page).not_to have_field('user[person_attributes][phone_number]', with: old_phone_number)
    end

    it "show phone number validation error message" do
      sign_in @user
      invalid_phone_number = 'abcd'
      visit edit_user_registration_path
      fill_in 'user[person_attributes][phone_number]', with: invalid_phone_number
      page.find('#update-user-account').click
      expect(page).to have_text('error')

    end

    it "includes an input field to change the room where the person can be found" do
      sign_in @user
      @room = create :room
      visit edit_user_registration_path
      expect(page).to have_select('user[person_attributes][room_ids][]', with_options: [@room.name])
    end

    it "can update rooms" do
      sign_in @user
      room1 = create :room
      room2 = create :room, name: "C.2.3"
      @user.person.rooms = [room1]
      visit edit_user_registration_path
      select room2.name, from: 'user[person_attributes][room_ids][]'
      unselect room1.name, from: 'user[person_attributes][room_ids][]'
      page.find('#update-user-account').click
      visit edit_user_registration_path
      expect(page).to have_select('user[person_attributes][room_ids][]', selected: [room2.name])
    end

    it "includes a select field to change the day of an openingtime" do
      sign_in @user
      @openingtime = create :openingtime
      @user.person.openingtimes = [@openingtime]
      visit edit_user_registration_path
      expect(@user.person.openingtimes).to include(@openingtime)
      expect(page).to have_select('user[person_attributes][openingtimes_attributes][0][day]')
    end
  end
end
