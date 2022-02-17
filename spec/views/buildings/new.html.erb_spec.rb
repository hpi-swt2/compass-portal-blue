require 'rails_helper'

RSpec.describe "buildings/new", type: :view do
  before do
    assign(:building, Building.new(
                        name: "MyString",
                        location_latitude: 1.5,
                        location_longitude: 1.5
                      ))
  end

  it "renders new building form" do
    render

    assert_select "form[action=?][method=?]", buildings_path, "post" do

      assert_select "input[name=?]", "building[name]"

      assert_select "input[name=?]", "building[name_de]"

      assert_select "input[name=?]", "building[location_latitude]"

      assert_select "input[name=?]", "building[location_longitude]"
    end
  end
end
