require 'rails_helper'

RSpec.describe Openingtime, type: :model do
  it "does not fail when created with factory bot" do
    openingtime = FactoryBot.create(:openingtime)
    expect(openingtime.day).to eq(1)
  end
end
