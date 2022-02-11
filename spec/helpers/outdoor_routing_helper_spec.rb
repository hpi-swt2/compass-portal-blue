require 'rails_helper'

describe "Outdoor routing helper", type: :helper do
  it "calculates a route" do
    start = "52.393913,13.133082"
    destination = "52.393861,13.129606"
    expect(OutdoorRoutingHelper.calculate_route(start, destination)).not_to be_nil
  end

  context "without routing API available" do
    it "throws no error when a route cannot be calculated" do
      allow(HTTParty).to receive(:get).and_raise(StandardError)
      start = "52.393913,13.133082"
      destination = "52.393861,13.129606"
      expect(OutdoorRoutingHelper.calculate_route(start, destination)).to be_nil
      expect(HTTParty).to have_received(:get).once
    end
  end
end
