require 'rails_helper'

RSpec.describe Room, type: :model do
  it "has name, floor, coordinates, building, room type and person" do
    room = create :room
    building = create :building
    person = create :person

    expect(room.name).to eq('C.2.4')
    expect(room.name_de).to eq('C.2.4 de')
    expect(room.floor).to eq(2)
    expect(room.building.name).to eq(building.name)
    expect(room.building.name_de).to eq(building.name_de)
    expect(room.location_latitude).to eq(1.5)
    expect(room.location_longitude).to eq(3.5)
    expect(room.room_type).to eq('Bachelorproject office')
    expect(room.people.first.email).to eq(person.email)
  end

  it "can be querried about its occupancy status" do
    room = create :room
    create :event, :in_one_hour, room: room
    expect(room.free?).to be true
    create :event, :right_now, room: room
    expect(room.free?).to be false
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
