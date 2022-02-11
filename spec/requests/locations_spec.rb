require 'rails_helper'

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

RSpec.describe "/locations", type: :request do
  before do
    sign_in(create(:user, admin: true))
  end
  # Location. As you add validations to Location, be sure to
  # adjust the attributes here as well.

  let(:valid_attributes) do
    Location.new(name: "cafe", details: "cafe-details", location_longitude: 3.5, location_latitude: 1.5,
                 owners: [create(:user)]).attributes
  end

  let(:invalid_attributes) do
    Location.new(name: "cafe", details: "cafe-details", location_longitude: 500, location_latitude: 500).attributes
  end

  describe "GET /index" do
    it "renders a successful response" do
      Location.create! valid_attributes
      get locations_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      location = Location.create! valid_attributes
      get location_url(location)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_location_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      location = Location.create! valid_attributes
      get edit_location_url(location)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Location" do
        expect do
          post locations_url, params: { location: valid_attributes }
        end.to change(Location, :count).by(1)
      end

      it "redirects to the user editing page" do
        post locations_url, params: { location: valid_attributes }
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Location" do
        expect do
          post locations_url, params: { location: invalid_attributes }
        end.to change(Location, :count).by(0)
      end

      it "renders an unprocessable_entity response (i.e. to display the 'new' template)" do
        post locations_url, params: { location: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      new_location = Location.new(name: "cafe ZWEI!", details: "cafe-details ZWEI :O", location_longitude: 3.5,
                                  location_latitude: 1.5)
      let(:new_attributes) do
        new_location.attributes
      end

      it "updates the requested location" do
        location = Location.create! valid_attributes
        patch location_url(location), params: { location: new_attributes }
        location.reload
        expect(location.name).to eq(new_location.name)
        expect(location.details).to eq(new_location.details)
        expect(location.location_latitude).to eq(new_location.location_latitude)
        expect(location.location_longitude).to eq(new_location.location_longitude)
      end

      it "redirects to the user editing page" do
        location = Location.create! valid_attributes
        patch location_url(location), params: { location: new_attributes }
        location.reload
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end

    context "with invalid parameters" do
      it "renders an unprocessable_entity response (i.e. to display the 'edit' template)" do
        location = Location.create! valid_attributes
        patch location_url(location), params: { location: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested location" do
      location = Location.create! valid_attributes
      expect do
        delete location_url(location)
      end.to change(Location, :count).by(-1)
    end

    it "redirects to the user editing page" do
      location = Location.create! valid_attributes
      delete location_url(location)
      expect(response).to redirect_to(edit_user_registration_path)
    end
  end
end
