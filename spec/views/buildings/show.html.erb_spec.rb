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

  it "renders a link to see the rooms building on the map" do
    render
    expect(rendered).to have_selector("a[href='#{
      building_map_path(target: "#{@building.location_latitude},#{
        @building.location_longitude}")}']")
  end
end
