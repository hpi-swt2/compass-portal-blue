require 'rails_helper'
require 'date'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/rooms", type: :request do

  before do
    sign_in(create(:user, admin: true))
  end
  # Room. As you add validations to Room, be sure to
  # adjust the attributes here as well.

  let(:valid_attributes) do
    Room.new(name: "H-2.57", floor: 2, room_type: "seminar-room",
             location_longitude: 3.5, location_latitude: 1.5,
             building: create(:building),
             owners: [create(:user)]).attributes
  end

  let(:invalid_attributes) do
    Room.new.attributes
  end

  describe "GET /index" do
    it "renders a successful response" do
      Room.create! valid_attributes
      get rooms_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      room = Room.create! valid_attributes
      get room_url(room)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_room_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      room = Room.create! valid_attributes
      get edit_room_url(room)
      expect(response).to be_successful
    end
  end

  describe "GET /calendar" do
    it "renders a successful response" do
      room = Room.create! valid_attributes
      get room_calendar_url(room, start_date: "2022-01-12")
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Room" do
        expect do
          post rooms_url, params: { room: valid_attributes }
        end.to change(Room, :count).by(1)
      end

      it "redirects to the created room" do
        post rooms_url, params: { room: valid_attributes }
        expect(response).to redirect_to(edit_room_url(Room.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Room" do
        expect do
          post rooms_url, params: { room: invalid_attributes }
        end.to change(Room, :count).by(0)
      end

      it "renders an unprocessable_entity response (i.e. to display the 'new' template)" do
        post rooms_url, params: { room: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_room) do
        Room.new(name: "H-E.51", floor: "E", room_type: "seminar-room",
                 location_longitude: 3.5, location_latitude: 1.5,
                 building: create(:building))
      end
      let(:new_attributes) do
        new_room.attributes
      end

      it "updates the requested room" do
        room = Room.create! valid_attributes
        patch room_url(room), params: { room: new_attributes }
        room.reload
        expect(room.name).to eq(new_room.name)
        expect(room.floor).to eq(new_room.floor)
        expect(room.room_type).to eq(new_room.room_type)
        expect(room.building).to eq(new_room.building)
      end

      it "redirects to the room" do
        room = Room.create! valid_attributes
        patch room_url(room), params: { room: new_attributes }
        room.reload
        expect(response).to redirect_to(edit_room_url(room))
      end
    end

    context "with invalid parameters" do
      it "renders an unprocessable_entity response (i.e. to display the 'edit' template)" do
        room = Room.create! valid_attributes
        patch room_url(room), params: { room: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested room" do
      room = Room.create! valid_attributes
      expect do
        delete room_url(room)
      end.to change(Room, :count).by(-1)
    end

    it "redirects to the rooms list" do
      room = Room.create! valid_attributes
      delete room_url(room)
      expect(response).to redirect_to(rooms_url)
    end
  end
end
