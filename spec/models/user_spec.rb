require 'rails_helper'

RSpec.describe User, type: :model do
  # Returns a User instance that's not saved
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#build-strategies
  let(:user) { FactoryBot.build(:user) }
  role = FactoryBot.build :role 

  describe "creation using a factory" do

    it "creates a valid object" do
      expect(user).to be_valid
    end

    it "sets an email" do
      expect(user.email).not_to be_blank
    end

  end

  describe "relationships" do
    it "has an assignment" do
      user = described_class.reflect_on_association(:assignments)
      expect(user.macro).to eq :has_many
    end

    it "should have role" do
      expect(user.role? :admin).to be false
      user.roles << role
      expect(user.role? :admin).to be true
    end
  end
end
