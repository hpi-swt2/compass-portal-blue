require 'rails_helper'

RSpec.describe SearchResult, type: :model do
  # Returns a SearchResult instance that's not saved
  let(:search_result) { build :search_result }

  describe "creation using a factory" do

    it "creates a valid object" do
      expect(search_result).to be_valid
    end

    it "sets a title" do
      expect(search_result.title).not_to be_blank
    end

    it "is not persistent" do
      expect(search_result.persisted?).to be false
    end

    it "responds correctly to a position query" do
      expect(search_result.position_set?).to be false
      search_result_with_location = build :search_result, location_longitude: 52.394163, location_latitude: 13.132283
      expect(search_result_with_location.position_set?).to be true
    end
  end
end
