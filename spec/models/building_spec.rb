require 'rails_helper'

RSpec.describe Building, type: :model do
  it "has name, location_latitude, location_longitude" do
    building = FactoryBot.create :building

    expect(building.name).to eq('A')
    expect(building.location_latitude).to eq(1.5)
    expect(building.location_longitude).to eq(3.5)
  end
end
