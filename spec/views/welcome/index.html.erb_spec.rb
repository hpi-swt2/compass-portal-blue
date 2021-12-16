require 'rails_helper'

RSpec.describe "welcome/index", type: :view do
  it "has a room button" do
    render
    expect(rendered).to have_link "Rooms", href: "rooms/index"
  end
end