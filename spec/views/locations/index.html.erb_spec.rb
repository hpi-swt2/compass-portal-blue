require 'rails_helper'

RSpec.describe "locations/index", type: :view do
  before do
    assign(:locations, create_list(:location, 2))
  end

  it "renders a list of locations" do
    render
    assert_select "tr>td", text: "cafe".to_s, count: 2
    assert_select "tr>td>img[alt=?]", "default-location-photo", count: 2
  end
end
