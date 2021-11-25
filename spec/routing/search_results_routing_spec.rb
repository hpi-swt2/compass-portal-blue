require "rails_helper"

RSpec.describe SearchResultsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/search_results").to route_to("search_results#index")
    end
  end
end
