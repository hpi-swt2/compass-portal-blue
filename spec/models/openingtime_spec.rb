require 'rails_helper'

RSpec.describe Openingtime, type: :model do

  before do
    @openingtime = create :openingtime
  end

  it "does not fail when created with factory bot" do
    expect(@openingtime.day).to eq(1)
  end

  it "accepts days between 0 and 6" do
    (0..6).each do |index|
      @openingtime.day = index
      expect(@openingtime).to be_valid
    end
  end

  it "rejects days lower than 0" do
    @openingtime.day = -1
    expect(@openingtime).to be_invalid
    @openingtime.day = -5
    expect(@openingtime).to be_invalid
  end

  it "rejects days larger than 6" do
    @openingtime.day = 7
    expect(@openingtime).to be_invalid
    @openingtime.day = 1000
    expect(@openingtime).to be_invalid
  end

  it "can output its day as a string" do
    expect(@openingtime.day_as_string).to eq("Tuesday")
    @openingtime.day = 4
    expect(@openingtime.day_as_string).to eq("Friday")
  end
end
