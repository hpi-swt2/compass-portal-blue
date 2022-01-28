require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /roles" do
    it "returns http success" do
      get "/users/roles"
      expect(response).to have_http_status(:success)
    end
  end

end
