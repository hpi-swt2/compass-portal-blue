require 'rails_helper'

RSpec.describe Location, type: :model do
  before do
    @location = create :location
    @openingtime = create(:openingtime, timeable: @location)
  end

  it "has name, details, location_latitude, location_longitude" do
    expect(@location.name).to eq('cafe')
    expect(@location.details).to eq('cafe-details')
    expect(@location.location_latitude).to eq(1.5)
    expect(@location.location_longitude).to eq(3.5)
  end

  it "has openingtime" do
    expect(@openingtime.timeable).to eq(@location)
  end
end
