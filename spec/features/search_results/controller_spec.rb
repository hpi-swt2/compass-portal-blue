require 'rails_helper'

RSpec.describe "Search result list page", type: :feature do

  before do
    @user = User.new
    @controller = SearchResultsController.new
    allow(@controller).to receive(:current_user) { @user }
  end

  it "calculates polar coordinate distance correctly" do
    location1 = [52.393907, 13.133006] # tree in front of the main building
    location2 = [52.384291, 13.119056] # j building

    location1_radians = @controller.send(:location_to_radians, location1)
    location2_radians = @controller.send(:location_to_radians, location2)

    distance = @controller.send(:distance, location1_radians, location2_radians)
    expect(distance).to be_within(20.0).of(1252.0)
  end

  it "correctly parses the user location" do
    @user.delete_last_known_location
    no_location = @controller.send(:valid_user_location)
    expect(no_location).to be nil
    @user.update_last_known_location("52.3925591,13.1303072")
    location = @controller.send(:valid_user_location)
    expect(location[0]).to be_within(0.1).of(52.3925591)
    expect(location[1]).to be_within(0.1).of(13.1303072)
    @user.delete_last_known_location
  end
end
