require 'rails_helper'

RSpec.describe "buildings/index", type: :view do
  before do
    assign(:buildings, [
        (FactoryBot.create :building),
        (FactoryBot.create :building)
           ])
  end

  it "renders a list of buildings" do
    render
    assert_select "tr>td", text: "A".to_s, count: 2
    assert_select "tr>td", text: 1.5.to_s, count: 2
    assert_select "tr>td", text: 3.5.to_s, count: 2
  end
end
