require 'rails_helper'

RSpec.describe "openingtimes/show", type: :view do
  before do
    @building = create :building
    @openingtime = assign(:openingtime, Openingtime.create!(
                                          day: 2,
                                          opens: Tod::TimeOfDay.new(8, 0),
                                          closes: Tod::TimeOfDay.new(17, 0),
                                          timeable: @building
                                        ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
