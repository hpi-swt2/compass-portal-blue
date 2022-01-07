require 'rails_helper'

describe "Person Show Page", type: :feature do
  before do
    @person = FactoryBot.create :person
  end

  it "displays a persons' information" do
    visit person_path(@person)

    expect(page).to have_text @person.first_name
    expect(page).to have_text @person.last_name
    expect(page).to have_text @person.email
    expect(page).to have_text @person.phone_number
  end

  it "displays the rooms where the person can be found" do
    room1 = create :room
    room2 = create :room, name: 'C.E.5'
    @person.rooms = [room1, room2]

    visit person_path(@person)

    expect(page).to have_text room1.name
    expect(page).to have_link 'Map', href:
      building_map_path(target: "#{room1.building.location_latitude},#{room1.building.location_longitude}")
    expect(page).to have_text room2.name
    expect(page).to have_link 'Map', href:
      building_map_path(target: "#{room2.building.location_latitude},#{room2.building.location_longitude}")
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
