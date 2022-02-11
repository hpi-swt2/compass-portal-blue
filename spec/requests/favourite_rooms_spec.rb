require 'rails_helper'

RSpec.describe "FavouriteRooms", type: :request do
  describe "PUT /favourite" do
    it "updates the rooms favoured by the user currently logged in" do
      @user = create(:user)
      sign_in(@user)
      room = create(:room)
      expect(@user.favourites).to eq([])
      put put_favourite_rooms_url(room), params: { favourite: true }, as: :json
      expect(@user.favourites).to include(->(r) { r.id == room.id })
      put put_favourite_rooms_url(room), params: { favourite: false }, as: :json
      @user.reload
      expect(@user.favourites).to eq([])
    end
  end
end
