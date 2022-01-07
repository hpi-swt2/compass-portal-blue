require 'rails_helper'

RSpec.describe "locations/show", type: :view do
  before do
    @location = create :location
  end

  it "renders attributes" do
    render
    expect(rendered).to match(/cafe/)
    expect(rendered).to match(/cafe-details/)
  end
end
