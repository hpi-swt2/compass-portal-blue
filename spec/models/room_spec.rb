require 'rails_helper'

RSpec.describe Room, type: :model do
  it "has name, floor, building, room type and user" do
    room = FactoryBot.create :room
    building = FactoryBot.create :building
    user = FactoryBot.create :user

    expect(room.name).to eq('C.2.4')
    expect(room.floor).to eq("2")
    expect(room.building.name).to eq(building.name)
    expect(room.room_type).to eq('Bachelorproject office')
    expect(room.user.name).to eq(user.name)
  end

  it "has a building" do
    subject {described_class.new}
    room = described_class.reflect_on_association(:building)
    expect(room.macro).to eq :belongs_to
  end

  it "has a user" do
    subject {described_class.new}
    user = described_class.reflect_on_association(:user)
    expect(room.macro).to eq :belongs_to
  end
end
