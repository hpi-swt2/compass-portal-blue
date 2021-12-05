require 'rails_helper'

RSpec.describe "buildings/index", type: :view do
  before do
    assign(:buildings, [
             Building.create!(
               name: "Name",
               location_latitude: 2.5,
               location_longitude: 3.5
             ),
             Building.create!(
               name: "Name",
               location_latitude: 2.5,
               location_longitude: 3.5
             )
           ])
  end

  it "renders a list of buildings" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: 2.5.to_s, count: 2
    assert_select "tr>td", text: 3.5.to_s, count: 2
  end
end
