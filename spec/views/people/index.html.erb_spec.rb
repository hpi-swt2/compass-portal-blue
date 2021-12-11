require 'rails_helper'

RSpec.describe "people/index", type: :view do
  before do
    assign(:people, create_list(:person, 2))
  end

  it "renders a list of people" do
    render
    assert_select "tr>td", text: "+4990909090".to_s, count: 2
    assert_select "tr>td", text: "Herbert".to_s, count: 2
    assert_select "tr>td", text: "Herbertson".to_s, count: 2
    assert_select "tr>td", text: "herbert.herbertson@hpi.de".to_s, count: 2
  end
end
