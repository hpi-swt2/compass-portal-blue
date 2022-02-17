require 'rails_helper'

RSpec.describe "Favourites", type: :request do
  describe "PUT /rooms" do
    it "updates the rooms favoured by the user currently logged in" do
      @user = create(:user)
      sign_in(@user)
      room = create(:room)
      expect(@user.favourites).to eq([])
      put put_favourite_rooms_url(room), params: { favourite: true }, as: :json
      @user.reload
      expect(@user.favourites).to include(->(f) { f.favourable.id == room.id })
      put put_favourite_rooms_url(room), params: { favourite: false }, as: :json
      @user.reload
      expect(@user.favourites).to eq([])
    end
  end

  describe "PUT /buildings" do
    it "updates the buildings favoured by the user currently logged in" do
      @user = create(:user)
      sign_in(@user)
      building = create(:building)
      expect(@user.favourites).to eq([])
      put put_favourite_buildings_url(building), params: { favourite: true }, as: :json
      @user.reload
      expect(@user.favourites).to include(->(f) { f.favourable.id == building.id })
      put put_favourite_buildings_url(building), params: { favourite: false }, as: :json
      @user.reload
      expect(@user.favourites).to eq([])
    end
  end

  describe "PUT /locations" do
    it "updates the locations favoured by the user currently logged in" do
      @user = create(:user)
      sign_in(@user)
      location = create(:location)
      expect(@user.favourites).to eq([])
      put put_favourite_locations_url(location), params: { favourite: true }, as: :json
      @user.reload
      expect(@user.favourites).to include(->(f) { f.favourable.id == location.id })
      put put_favourite_locations_url(location), params: { favourite: false }, as: :json
      @user.reload
      expect(@user.favourites).to eq([])
    end
  end

  describe "PUT /people" do
    it "updates the people favoured by the user currently logged in" do
      @user = create(:user)
      sign_in(@user)
      person = create(:person)
      expect(@user.favourites).to eq([])
      put put_favourite_people_url(person), params: { favourite: true }, as: :json
      @user.reload
      expect(@user.favourites).to include(->(f) { f.favourable.id == person.id })
      put put_favourite_people_url(person), params: { favourite: false }, as: :json
      @user.reload
      expect(@user.favourites).to eq([])
    end
  end
end
