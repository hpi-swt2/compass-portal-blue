require 'rails_helper'

RSpec.describe "openingtimes/index", type: :view do
  before do
    @building = create :building
    assign(:openingtimes, [
             Openingtime.create!(
               day: 2,
               opens: Tod::TimeOfDay.new(8, 0),
               closes: Tod::TimeOfDay.new(17, 0),
               timeable: @building
             ),
             Openingtime.create!(
               day: 2,
               opens: Tod::TimeOfDay.new(8, 0),
               closes: Tod::TimeOfDay.new(17, 0),
               timeable: @building
             )
           ])
  end

  it "renders a list of openingtimes" do
    render
    assert_select "tr>td", text: 2.to_s, count: 2
  end
end
