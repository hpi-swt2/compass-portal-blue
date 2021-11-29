require 'rails_helper'

RSpec.describe "openingtimes/edit", type: :view do
  before(:each) do
    @openingtime = assign(:openingtime, Openingtime.create!(
      day: 1
    ))
  end

  it "renders the edit openingtime form" do
    render

    assert_select "form[action=?][method=?]", openingtime_path(@openingtime), "post" do

      assert_select "input[name=?]", "openingtime[day]"
    end
  end
end
