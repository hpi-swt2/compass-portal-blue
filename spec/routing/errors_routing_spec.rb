require "rails_helper"

RSpec.describe BuildingsController, type: :routing do
  describe "redirecting", type: :request do
    it "redirects from rooms/new to error/show" do
      get "/rooms/new"
      expect(response).to redirect_to("/error/show")
    end

    it "redirects from people/new to error/show" do
      get "/people/new"
      expect(response).to redirect_to("/error/show")
    end

    it "redirects from locations/new to error/show" do
      get "/locations/new"
      expect(response).to redirect_to("/error/show")
    end

    it "redirects from buildings/new to error/show" do
      get "/buildings/new"
      expect(response).to redirect_to("/error/show")
    end
  end
end
