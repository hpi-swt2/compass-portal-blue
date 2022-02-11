require 'rails_helper'

describe "Routing helper", type: :helper do
  it "displays time as minutes and seconds" do
    expect(RoutingHelper.format_seconds_as_minsec(514)).to match(/\d{2,}:\d{2}/)
    expect(RoutingHelper.format_seconds_as_minsec(514)).to eq "08:34"
    expect(RoutingHelper.format_seconds_as_minsec(30)).to eq "00:30"
  end

  context "when looking up coordinates" do
    it "lets valid coordinates pass" do
      location = "52.393913,13.133082"
      expect(RoutingHelper.resolve_coordinates(location)).to eq location
    end

    it "looks up the locations of buildings" do
      Building.create!(
        name: 'Haus G',
        location_latitude: "52.3947488",
        location_longitude: "13.1248368"
      )
      expect(RoutingHelper.resolve_coordinates("Haus G")).to eq "52.3947488,13.1248368"
    end

    it "rejects invalid input" do
      expect(RoutingHelper.resolve_coordinates("Haus ASDFQWERTZ")).to eq nil
    end
  end
end
