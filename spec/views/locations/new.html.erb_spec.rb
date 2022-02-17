require 'rails_helper'

RSpec.describe "locations/new", type: :view do
  before do
    @location = create :location
    #    assign(:person, Person.new(
    #                      phone_number: "MyString",
    #                      first_name: "MyString",
    #                      last_name: "MyString",
    #                      email: "MyString"
    #                    ))
  end

  it "renders new location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do

      assert_select "input[name=?]", "location[name]"

      assert_select "input[name=?]", "location[name_de]"

      assert_select "input[name=?]", "location[details]"

      assert_select "input[name=?]", "location[details_de]"

      assert_select "input[name=?]", "location[location_photo]"

      assert_select "input[name=?]", "location[location_latitude]"

      assert_select "input[name=?]", "location[location_longitude]"
    end
  end
end
