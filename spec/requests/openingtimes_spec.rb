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

RSpec.describe "/openingtimes", type: :request do

  # Openingtime. As you add validations to Openingtime, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    Openingtime.new(day: 6,
                    opens: Tod::TimeOfDay(8),
                    closes: Tod::TimeOfDay(17),
                    timeable: FactoryBot.create(:building)).attributes
  end

  let(:invalid_attributes) do
    Openingtime.new(day: 7, opens: Tod::TimeOfDay(8), closes: Tod::TimeOfDay(17)).attributes
  end

  describe "GET /index" do
    it "renders a successful response" do
      Openingtime.create! valid_attributes
      get openingtimes_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      openingtime = Openingtime.create! valid_attributes
      get openingtime_url(openingtime)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_openingtime_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      openingtime = Openingtime.create! valid_attributes
      get edit_openingtime_url(openingtime)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Openingtime" do
        expect do
          post openingtimes_url, params: { openingtime: valid_attributes }
        end.to change(Openingtime, :count).by(1)
      end

      it "redirects to the created openingtime" do
        post openingtimes_url, params: { openingtime: valid_attributes }
        expect(response).to redirect_to(openingtime_url(Openingtime.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Openingtime" do
        expect do
          post openingtimes_url, params: { openingtime: invalid_attributes }
        end.to change(Openingtime, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post openingtimes_url, params: { openingtime: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      new_openingtime = Openingtime.new(day: 3,
                                        opens: Tod::TimeOfDay(10),
                                        closes: Tod::TimeOfDay(12),
                                        timeable: FactoryBot.create(:building))
      let(:new_attributes) do
        new_openingtime.attributes
      end

      it "updates the requested openingtime" do
        openingtime = Openingtime.create! valid_attributes
        patch openingtime_url(openingtime), params: { openingtime: new_attributes }
        openingtime.reload
        expect(openingtime.day).to eq(new_openingtime.day)
        expect(openingtime.opens).to eq(new_openingtime.opens)
        expect(openingtime.closes).to eq(new_openingtime.closes)
      end

      it "redirects to the openingtime" do
        openingtime = Openingtime.create! valid_attributes
        patch openingtime_url(openingtime), params: { openingtime: new_attributes }
        openingtime.reload
        expect(response).to redirect_to(openingtime_url(openingtime))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        openingtime = Openingtime.create! valid_attributes
        patch openingtime_url(openingtime), params: { openingtime: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested openingtime" do
      openingtime = Openingtime.create! valid_attributes
      expect do
        delete openingtime_url(openingtime)
      end.to change(Openingtime, :count).by(-1)
    end

    it "redirects to the openingtimes list" do
      openingtime = Openingtime.create! valid_attributes
      delete openingtime_url(openingtime)
      expect(response).to redirect_to(openingtimes_url)
    end
  end
end
