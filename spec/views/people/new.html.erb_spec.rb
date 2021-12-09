require 'rails_helper'

RSpec.describe "people/new", type: :view do
  before do
    assign(:person, Person.new(
                      phone_number: "MyString",
                      first_name: "MyString",
                      last_name: "MyString",
                      email: "MyString"
                    ))
  end

  it "renders new person form" do
    render

    assert_select "form[action=?][method=?]", people_path, "post" do

      assert_select "input[name=?]", "person[phone_number]"

      assert_select "input[name=?]", "person[first_name]"

      assert_select "input[name=?]", "person[last_name]"

      assert_select "input[name=?]", "person[email]"
    end
  end
end
