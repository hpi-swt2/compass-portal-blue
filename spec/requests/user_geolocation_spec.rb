require 'rails_helper'

RSpec.describe "/users/geo_location", type: :request do
  before do
    @user = create(:user)
  end

  it "isn't manipulated by the cleaner task" do
    expect(User.cleaner_task).to be_nil
  end

  describe "PUT /users/geo_location" do
    it "doesn't allow requests from unauthenticated users" do
      put users_geo_location_url, params: { location: "42.42,13.37" }
      expect(response).to have_http_status :unauthorized
    end

    it "rejects invalid locations" do
      sign_in @user

      expect(@user.last_known_location).to be_nil

      put users_geo_location_url
      expect(response).to have_http_status :bad_request
      expect(@user.last_known_location).to be_nil

      put users_geo_location_url, params: { location: "Room H-2.O" }
      expect(response).to have_http_status :bad_request
      expect(@user.last_known_location).to be_nil
    end

    it "updates the user location" do
      sign_in @user

      expect(@user.last_known_location).to be_nil

      put users_geo_location_url, params: { location: "42.42,13.37" }
      expect(response).to be_successful
      expect(@user.last_known_location).to eq("42.42,13.37")
    end
  end

  describe "DELETE /users/geo_location" do
    it "doesn't allow requests from unauthenticated users" do
      delete users_geo_location_url
      expect(response).to have_http_status :unauthorized
    end

    it "deletes the location of the user" do
      sign_in @user
      @user.update_last_known_location "42.42,13.37"

      expect(@user.last_known_location).not_to be_nil
      delete users_geo_location_url
      expect(@user.last_known_location).to be_nil
    end

    it "signals when there is nothing to delete" do
      sign_in @user
      expect(@user.last_known_location).to be_nil

      delete users_geo_location_url
      expect(response).to have_http_status :not_found
    end
  end
end
