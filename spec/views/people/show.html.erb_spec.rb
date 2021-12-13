require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before do
    @person = create :person
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/\+4990909090/)
    expect(rendered).to match(/Herbert/)
    expect(rendered).to match(/Herbertson/)
    expect(rendered).to match(/herbert.herbertson@hpi.de/)
  end
end
