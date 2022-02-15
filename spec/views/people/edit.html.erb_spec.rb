require 'rails_helper'

RSpec.describe "people/edit", type: :view do
  before do
    @person = create :person
  end

  it "renders the edit person form" do
    render

    assert_select "form[action=?][method=?]", person_path(@person), "post" do

      assert_select "input[name=?]", "person[phone_number]"

      assert_select "input[name=?]", "person[first_name]"

      assert_select "input[name=?]", "person[last_name]"

      assert_select "input[name=?]", "person[email]"

      assert_select "input[name=?]", "person[room_ids][]"
    end
  end
end
