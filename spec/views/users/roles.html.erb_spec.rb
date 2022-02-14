require 'rails_helper'

RSpec.describe "users/roles.html.erb", type: :view do
  before do
    assign(:users, [
             User.new(
               username: "User 1",
               admin: false
             ),
             User.new(
               username: "User 2",
               admin: true
             )
           ])
  end

  it "lists all users" do
    render
    expect(rendered).to match(/User 1/)
    expect(rendered).to match(/User 2/)
  end
end
