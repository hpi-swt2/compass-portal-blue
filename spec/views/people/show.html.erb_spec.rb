require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before do
    @person = assign(:person, Person.create!(
                                phone_number: "Phone Number",
                                first_name: "First Name",
                                last_name: "Last Name",
                                email: "Email"
                              ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Phone Number/)
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Email/)
  end
end
