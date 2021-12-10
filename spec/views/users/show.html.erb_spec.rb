require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before do
    @user = assign(:user, User.create!(email: "x@y.z", password: "n0ŧ s@¢µr€"))
  end

  it "renders attributes in <p>" do
    render
  end
end
