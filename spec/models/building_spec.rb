require 'rails_helper'

RSpec.describe Building, type: :model do
  before do
    @building = create :building
    @openingtime = create :openingtime, timeable: @building
  end

  it "has name, location_latitude, location_longitude" do
    expect(@building.name).to eq('A')
    expect(@building.location_latitude).to eq(1.5)
    expect(@building.location_longitude).to eq(3.5)
  end

  it "has openingtime" do
    expect(@openingtime.timeable).to eq(@building)
  end
end
