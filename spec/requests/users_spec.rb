require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user = sign_in(create(:user, admin: true))
  end

  describe "GET /roles" do
    it "returns http success" do
      get "/users/roles"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT /update_roles" do
    it "updates the user's admin role" do
      dummy_user = create(:user, admin: false)
      put "/users/#{dummy_user.id}/roles", params: { roles: { admin: true } }
      expect(response).to have_http_status(:success)
      dummy_user.reload
      expect(dummy_user.admin).to eq(true)
    end
  end

end
