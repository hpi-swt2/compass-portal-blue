require 'rails_helper'

describe "Routing helper", type: :helper do
  it "calculates a route" do
    @start = "52.393913,13.133082"
    @destination = "52.393861,13.129606"
    expect(RoutingHelper.calculate_route(@start, @destination)).not_to be_nil
  end

  context "with wrong inputs" do
    it "can handle only partial parameters" do
      @start = "52.393913,13.133082"
      @destination = ""
      expect(RoutingHelper.calculate_route(@start, @destination)).to be_nil
    end

    it "can handle wrong parameters" do
      @start = "Hello"
      @destination = "World"
      expect(RoutingHelper.calculate_route(@start, @destination)).to be_nil
    end

    it "detects incorrect coordinates" do
      @start = "a52.393913,13.133082"
      @destination = "52.393913,13.133082"
      expect(RoutingHelper.calculate_route(@start, @destination)).to be_nil

      @start = "52.393913,13.133082k"
      @destination = "52.393913,13.133082"
      expect(RoutingHelper.calculate_route(@start, @destination)).to be_nil
    end
  end

  context "without routing API available" do
    it "throws no error when a route cannot be calculated" do
      allow(HTTParty).to receive(:get).and_raise(StandardError)
      @start = "52.393913,13.133082"
      @destination = "52.393861,13.129606"
      expect(RoutingHelper.calculate_route(@start, @destination)).to be_nil
      expect(HTTParty).to have_received(:get).once
    end
  end
end
