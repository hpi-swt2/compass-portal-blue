require "rails_helper"

RSpec.describe CalendarController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/calendar").to route_to("calendar#show")
    end
  end
end
