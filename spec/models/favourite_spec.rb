require 'rails_helper'

RSpec.describe Favourite, type: :model do
  it "has user_id and favourable_id" do
    room = create :room
    user = create :user
    favourite = described_class.new({ user: user, favourable: room })

    expect(favourite.favourable.name).to eq(room.name)
    expect(favourite.user.username).to eq(user.username)
  end

  it "has a favourable" do
    described_class.reflect_on_association(:favorable)
  end

  it "has a user" do
    described_class.reflect_on_association(:user)
  end
end
