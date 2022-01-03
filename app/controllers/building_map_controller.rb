class BuildingMapController < ApplicationController
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze

  def index
    @start = RoutingHelper.resolve_coordinates(params[:start])
    @destination = RoutingHelper.resolve_coordinates(params[:dest])
    @route = RoutingHelper.calculate_route(@start, @destination) if @start.present? && @destination.present?

    @target = params[:target]
  end
end
