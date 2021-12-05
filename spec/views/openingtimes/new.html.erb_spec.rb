require 'rails_helper'

RSpec.describe "openingtimes/new", type: :view do
  before do
    assign(:openingtime, Openingtime.new(
                           day: 1
                         ))
  end

  it "renders new openingtime form" do
    render

    assert_select "form[action=?][method=?]", openingtimes_path, "post" do

      assert_select "input[name=?]", "openingtime[day]"
    end
  end
end
