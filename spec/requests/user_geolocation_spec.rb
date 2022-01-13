require 'rails_helper'

RSpec.describe "/users/geo_location", type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe "PUT /users/geo_location" do
    it "doesn't allow requests from unauthenticated users" do
      put users_geo_location_url, params: { location: "42.42,13.37" }
      expect(response).to have_http_status :unauthorized
    end

    it "rejects invalid locations" do
      sign_in @user

      put users_geo_location_url
      expect(response).to have_http_status :bad_request

      put users_geo_location_url, params: { location: "Room H-2.O" }
      expect(response).to have_http_status :bad_request
    end

    it "updates the user location" do
      sign_in @user

      put users_geo_location_url, params: { location: "42.42,13.37" }
      expect(response).to be_successful
      expect(@user.last_known_position).to eq("42.42,13.37")

      put users_geo_location_url, params: { location: "52.12,6.66" }
      expect(response).to be_successful
      expect(@user.last_known_position).to eq("52.12,6.66")
    end
  end
end
