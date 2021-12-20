require 'rails_helper'

describe "Person Show Page", type: :feature do
  it "displays a persons' information" do
    @person_details = FactoryBot.create :person
    visit person_path(@person_details)

    expect(page).to have_text @person_details.first_name
    expect(page).to have_text @person_details.last_name
    expect(page).to have_text @person_details.email
    expect(page).to have_text @person_details.phone_number
  end
end
