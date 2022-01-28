require 'rails_helper'

RSpec.describe "rooms/show", type: :view do
  before do
    @building = create :building
    @people = [(create :person)]
    @room = assign(:room, Room.create!(
                            name: "Name",
                            floor: 0,
                            room_type: "seminar-room",
                            people: @people,
                            building: @building
                          ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Room type/)
    expect(rendered).to match(/Floor/)
    expect(rendered).to match(/People/)
  end

end
