require 'rails_helper'
require 'people_helper'

describe "Person Show Page", type: :feature do
  before do
    @person = create :person
    sign_in(create(:user, admin: true))
  end

  it "displays a person's information" do
    visit person_path(@person)

    expect(page).to have_text @person.first_name
    expect(page).to have_text @person.last_name
    expect(page).to have_link @person.email, href: "mailto:#{@person.email}"
    expect(page).to have_link @person.phone_number, href: "tel:#{@person.phone_number}"
  end

  it "displays the rooms where the person can be found" do
    room1 = create :room
    room2 = create :room, name: 'C.E.5'
    @person.rooms = [room1, room2]

    visit person_path(@person)

    expect(page).to have_link room1.name, href: room_path(room1, locale: I18n.locale)
    expect(page).to have_link room2.name, href: room_path(room2, locale: I18n.locale)
  end

  it "displays the office hours of the person" do
    office_hour1 = create :openingtime
    office_hour2 = create :openingtime, day: 2
    @person.openingtimes = [office_hour1, office_hour2]

    visit person_path(@person)

    expect(page).to have_text office_hour1.to_string
    expect(page).to have_text office_hour2.to_string
  end
end
