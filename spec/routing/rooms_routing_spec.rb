require "rails_helper"

RSpec.describe RoomsController, type: :routing do
  before do
    @building = create :building
    @people = [(create :person)]
    @room = assign(:room, Room.create!(
                            name: "Seminarraum 1",
                            floor: 0,
                            room_type: "seminar-room",
                            people: @people,
                            building: @building
                          ))
    @events = [Event.create!(name: "Test Event", description: "CG", d_start: Time.zone.now,
                             d_end: Time.zone.now, recurring: "", room_id: @room.id)]
    @date = Time.zone.now
    @month = Date::MONTHNAMES[Time.zone.today.month]
    @year = Time.zone.now.year
  end
  
  describe "routing" do
    it "routes to #index" do
      expect(get: "/rooms").to route_to("rooms#index")
    end

    it "routes to #new" do
      expect(get: "/rooms/new").to route_to("rooms#new")
    end

    it "routes to #show" do
      expect(get: "/rooms/1").to route_to("rooms#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/rooms/1/edit").to route_to("rooms#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/rooms").to route_to("rooms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/rooms/1").to route_to("rooms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/rooms/1").to route_to("rooms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/rooms/1").to route_to("rooms#destroy", id: "1")
    end

    it "routes to #calendar" do
      expect(get: "/calendar").to route_to("rooms#calendar")
    end
  end
end
