require 'rails_helper'

RSpec.describe "Maps", type: :request do
  describe "GET /map/" do
    it "returns http success" do
      get "/map"
      expect(response).to have_http_status(:success)
    end
  end

end
