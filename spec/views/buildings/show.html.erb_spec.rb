require 'rails_helper'

RSpec.describe "buildings/show", type: :view do
  before do
    @building = assign(:building, Building.create!(
                                    name: "Name",
                                    location_latitude: 2.5,
                                    location_longitude: 3.5
                                  ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/3.5/)
  end
end
