class BuildingMapController < ApplicationController
  def index
    @start = RoutingHelper.resolve_coordinates(params[:start])
    @destination = RoutingHelper.resolve_coordinates(params[:dest])
    @route = RoutingHelper.calculate_route(@start, @destination) if @start.present? && @destination.present?

    @target = params[:target]
  end
end
