require 'rails_helper'

RSpec.describe User, type: :model do
  # Returns a User instance that's not saved
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#build-strategies

  describe "creation using a factory" do
    let(:user) { build(:user) }

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

  describe "last known location" do
    let(:user) { build(:user) }

    it "disposes of outdated information" do
      expect(user.last_known_location).to be_nil
      user.update_last_known_location("13.37,47.11")

      user.last_known_location_with_timestamp[1] = DateTime.parse("14th April 1954")

      expect(user.last_known_location).not_to be_nil
      described_class.clean_outdated_locations
      expect(user.last_known_location).to be_nil
    end
  end
end
