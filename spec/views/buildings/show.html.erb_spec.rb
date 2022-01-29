require 'rails_helper'

RSpec.describe "buildings/show", type: :view do
  before do
    @building = create :building
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/A/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/3.5/)
  end
end
