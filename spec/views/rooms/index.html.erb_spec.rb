require 'rails_helper'

RSpec.describe "rooms/index", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @rooms = Room.create([{ name: "Hörsaal1", floor: 0, room_type: "Hörsaal" },
                          { name: "H.257", floor: 2, room_type: "Seminarraum" }]) do |u|
      u.people = @people
      u.building = @building
    end
  end

  it "renders a list of rooms" do
    render
    assert_select "tr>td", text: "Seminarräume:".to_s, count: 1
    assert_select "tr>td", text: "H.257".to_s, count: 1
    assert_select "tr>td", text: "Hörsäle:".to_s, count: 1
    assert_select "tr>td", text: "Hörsaal1".to_s, count: 1
    assert_select "tr>td", text: "Poolräume:".to_s, count: 1
    assert_select "tr>td", text: "Konferenzräume:".to_s, count: 1
  end
end
