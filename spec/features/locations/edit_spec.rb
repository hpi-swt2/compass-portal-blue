require 'rails_helper'

describe "location edit page", type: :feature do
  before do
    @location = FactoryBot.create :location
  end

  it "exists at 'edit_author_path' and render without error" do
    visit edit_location_url(@location)
    page.fill_in 'location[name]', with: 'Updated_name'
    page.fill_in 'location[details]', with: 'Updated_details'
    page.fill_in 'location[location_latitude]', with: 14.0
    page.fill_in 'location[location_longitude]', with: 20.0
    find('input[type="submit"]').click

    expect(Location.where(name: "Updated_name", details: "Updated_details", location_latitude: 14.0,
                          location_longitude: 20.0)).to exist
  end

  it "can update photo" do
    @location.location_photo.attach(
      io: File.open('app/assets/images/default-profile-picture.png'),
      filename: 'default-profile-picture.png',
      content_type: 'image/png'
    )
    filename = @location.location_photo.filename
    @location.location_photo.detach
    visit location_path(@location)
    expect(page).not_to have_css "img[alt='#{filename}']"

    visit edit_location_path(@location)
    page.attach_file('location[location_photo]', 'app/assets/images/default-profile-picture.png')
    page.find('input[type=submit][name=commit]').click

    visit location_path(@location)
    expect(page).to have_css "img[alt='#{filename}']"
  end
end
