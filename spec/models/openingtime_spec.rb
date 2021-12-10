require 'rails_helper'

RSpec.describe Openingtime, type: :model do

  before(:each) do
    @openingtime = FactoryBot.create(:openingtime)
  end

  it "does not fail when created with factory bot" do
    expect(@openingtime.day).to eq(1)
  end

  it "should accept days between 1 and 7" do
    @openingtime.day = 1
    expect(@openingtime).to be_valid
    @openingtime.day = 4
    expect(@openingtime).to be_valid
    @openingtime.day = 7
    expect(@openingtime).to be_valid
  end

  it "should reject days lower than 1" do
    @openingtime.day = 0
    expect(@openingtime).to be_invalid
    @openingtime.day = -5
    expect(@openingtime).to be_invalid
  end

  it "should reject days larger than 7" do
    @openingtime.day = 8
    expect(@openingtime).to be_invalid
    @openingtime.day = 1000
    expect(@openingtime).to be_invalid
  end
end
