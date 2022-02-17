require 'rails_helper'
require 'date'

RSpec.describe "/calendar", type: :request do

  before do
    sign_in(create(:user, admin: true))
  end

  let(:valid_attributes) do
    Event.new(name: "BA Mathematik III Übung",
              description: "Teaching mathematics",
              room: create(:room),
              start_time: "2021-10-25 13:15:00",
              end_time: "2021-10-25 14:45:00",
              recurring: IceCube::Rule.weekly.day(:monday).to_yaml).attributes
  end

  describe "GET" do
    it "renders a successful response" do
      Event.create! valid_attributes
      get calendar_path(start_date: "2021-10-24", event_id: 1)
      expect(response).to be_successful
    end
  end
end
