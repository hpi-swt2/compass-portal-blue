require "rails_helper"

RSpec.describe OpeningtimesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/openingtimes").to route_to("openingtimes#index")
    end

    it "routes to #new" do
      expect(get: "/openingtimes/new").to route_to("openingtimes#new")
    end

    it "routes to #show" do
      expect(get: "/openingtimes/1").to route_to("openingtimes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/openingtimes/1/edit").to route_to("openingtimes#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/openingtimes").to route_to("openingtimes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/openingtimes/1").to route_to("openingtimes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/openingtimes/1").to route_to("openingtimes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/openingtimes/1").to route_to("openingtimes#destroy", id: "1")
    end
  end
end
