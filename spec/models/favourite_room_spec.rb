require 'rails_helper'

RSpec.describe FavouriteRoom, type: :model do
  it "has user_id and room_id" do
    favourite_room = FactoryBot.create :favourite_room
    room = FactoryBot.create :room
    user = FactoryBot.create :user

    expect(favourite_room.room.name).to eq(room.name)
    expect(favourite_room.user.username).to eq(user.username)
  end

  it "has a room" do
    favourite_room = described_class.reflect_on_association(:room)
    expect(favourite_room.macro).to eq :belongs_to
  end

  it "has a user" do
    favourite_room = described_class.reflect_on_association(:user)
    expect(favourite_room.macro).to eq :belongs_to
  end
end
