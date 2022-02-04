require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    sign_in(create(:user, admin: true))
  end

  describe "GET /roles" do
    it "returns http success" do
      get "/users/roles"
      expect(response).to have_http_status(:success)
    end
  end

end
