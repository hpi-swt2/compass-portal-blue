require 'rails_helper'

RSpec.describe Room, type: :model do
  it "has name, floor, building, room type and person" do
    room = FactoryBot.create :room
    building = FactoryBot.create :building
    person = FactoryBot.create :person

    expect(room.name).to eq('C.2.4')
    expect(room.floor).to eq(2)
    expect(room.building.name).to eq(building.name)
    expect(room.room_type).to eq('Bachelorproject office')
    expect(room.people.first.email).to eq(person.email)
  end

  it "has a building" do
    room = described_class.reflect_on_association(:building)
    expect(room.macro).to eq :belongs_to
  end

  it "has a person" do
    room = described_class.reflect_on_association(:people)
    expect(room.macro).to eq :has_and_belongs_to_many
  end
end
