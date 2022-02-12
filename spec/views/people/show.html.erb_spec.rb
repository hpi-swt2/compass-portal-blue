require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before do
    @person = create :person
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/\+4990909090/)
    expect(rendered).to match(/Herbert/)
    expect(rendered).to match(/Herbertson/)
    expect(rendered).to match(/herbert.herbertson@hpi.de/)
  end

  it "doesn't show any directions by default" do
    render
    expect(rendered).not_to have_link "Directions"
    expect(rendered).not_to have_text "Last known location"
    expect(rendered).not_to match(/route\?dest=/)
  end

  describe "with owner" do
    before do
      @user = create :user
      @user.person = @person
      @person.owners << @user
    end

    after do
      @person.owners.delete @user
    end

    it "shows directions to the last known location" do
      @user.update_last_known_location "13.37,47.11"
      render
      expect(rendered).to have_text "Last known location"
      expect(rendered).to have_link @user.last_known_location
      expect(rendered).to match(/route\?dest=/)
    end

    it "doesn't show directions if the owners position is unknown" do
      @user.delete_last_known_location
      render
      expect(rendered).not_to have_text "Last known location"
      expect(rendered).not_to match(/route\?dest=/)
    end
  end

  describe "with owned room" do
    before do
      @room = create :room
      @person.rooms << @room
    end

    after do
      @person.rooms.delete @room
    end

    it "shows the navigation to the owned room" do
      render
      expect(rendered).to have_link "Directions"
      expect(rendered).to match(/route\?dest=/)
    end
  end
end
