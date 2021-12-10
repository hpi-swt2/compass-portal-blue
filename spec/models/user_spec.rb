require 'rails_helper'

RSpec.describe User, type: :model do
  # Returns a User instance that's not saved
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#build-strategies

  describe "creation using a factory" do
    let(:user) { FactoryBot.build(:user) }

    it "creates a valid object" do
      expect(user).to be_valid
    end

    it "sets an email" do
      expect(user.email).not_to be_blank
    end

  end

  describe "creation using constructor" do
    let(:user) { described_class.new(email: "herbert.herbertson@hpi.de") }

    it "has a person with matching email" do
      expect(user.person).not_to be_nil
      expect(user.person.email).to eq("herbert.herbertson@hpi.de")
    end
  end
end
