require 'rails_helper'

RSpec.describe "locations/edit", type: :view do
  before do
    @location = create :location
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do

      assert_select "input[name=?]", "location[name]"

      assert_select "input[name=?]", "location[details]"

      assert_select "input[name=?]", "location[location_photo]"

      assert_select "input[name=?]", "location[location_latitude]"

      assert_select "input[name=?]", "location[location_longitude]"

      assert_select "input[name=?]", "location[location_longitude]"
    end
  end
end
