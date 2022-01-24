require 'rails_helper'

RSpec.describe "buildings/edit", type: :view do
  before do
    @building = create :building
  end

  it "renders the edit building form" do
    render

    assert_select "form[action=?][method=?]", building_path(@building), "post" do

      assert_select "input[name=?]", "building[name]"

      assert_select "input[name=?]", "building[location_latitude]"

      assert_select "input[name=?]", "building[location_longitude]"
    end
  end
end
