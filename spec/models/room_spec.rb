require 'rails_helper'

RSpec.describe Room, type: :model do
  it "has name, floor, building, room type and contact person" do
    room = FactoryBot.create :room
    building = FactoryBot.create :building

    expect(room.name).to eq('C.2.4')
    expect(room.floor).to eq("2")
    expect(room.building.name).to eq(building.name)
    expect(room.room_type).to eq('Bachelorproject office')
    expect(room.contact_person).to eq('Jonas Cremerius')
  end

  it "has a building" do
    subject {described_class.new}
    room = described_class.reflect_on_association(:building)
    expect(room.macro).to eq :belongs_to
  end
end
