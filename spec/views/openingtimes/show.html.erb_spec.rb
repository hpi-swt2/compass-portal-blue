require 'rails_helper'

RSpec.describe "openingtimes/show", type: :view do
  before(:each) do
    @openingtime = assign(:openingtime, Openingtime.create!(
      day: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
