require 'rails_helper'
require 'ice_cube'

RSpec.describe Event, type: :model do
  it "has name, description, d_start, d_room, room and recurrence rule" do
    event = create :event
    room = create :room

    expect(event.name).to eq('BA Mathematik III Übung')
    expect(event.description).to eq("Teaching mathematics")
    expect(event.room.name).to eq(room.name)
    expect(event.d_start).to eq("2021-10-25 13:15:00")
    expect(event.d_end).to eq("2021-10-25 14:45:00")
    expect(event.rule).to eq(IceCube::Rule.weekly.day(:monday))
  end

  it "has a room" do
    event = described_class.reflect_on_association(:room)
    expect(event.macro).to eq :belongs_to
  end
end
