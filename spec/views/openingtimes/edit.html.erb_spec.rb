require 'rails_helper'

RSpec.describe "openingtimes/edit", type: :view do
  before do
    @building = create :building
    @openingtime = assign(:openingtime, Openingtime.create!(
                                          day: 1,
                                          opens: Tod::TimeOfDay.new(8, 0),
                                          closes: Tod::TimeOfDay.new(17, 0),
                                          timeable: @building
                                        ))
  end

  it "renders the edit openingtime form" do
    render

    assert_select "form[action=?][method=?]", openingtime_path(@openingtime), "post" do

      assert_select "select[name=?]", "openingtime[day]"
    end
  end
end
