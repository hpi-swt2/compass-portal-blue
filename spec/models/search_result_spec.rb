require 'rails_helper'

RSpec.describe SearchResult, type: :model do
  # Returns a SearchResult instance that's not saved
  let(:search_result) { build(:search_result) }

  describe "creation using a factory" do

    it "creates a valid object" do
      expect(search_result).to be_valid
    end

    it "sets a title" do
      expect(search_result.title).not_to be_blank
    end

  end
end
