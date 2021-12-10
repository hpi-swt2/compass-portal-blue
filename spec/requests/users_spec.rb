require 'rails_helper'


RSpec.describe "/users", type: :request do
  describe "GET /show" do
    it "renders a successful response" do
      user = create :user
      get user_url(user)
      expect(response).to be_successful
    end
  end
end
