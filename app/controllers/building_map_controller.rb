class BuildingMapController < ApplicationController
  def index
    @start = RoutingHelper.coordinates(params[:start])
    puts @start
    @destination = RoutingHelper.coordinates(params[:dest])
    puts @destination
    @route = RoutingHelper.calculate_route(@start, @destination) if @start.present? && @destination.present?
  end
end
