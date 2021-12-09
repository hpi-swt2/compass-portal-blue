require 'rails_helper'

describe "Routing helper", type: :feature do
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
