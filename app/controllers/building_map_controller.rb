class BuildingMapController < ApplicationController
  def index
    @start = RoutingHelper.coordinates(params[:start])
    @destination = RoutingHelper.coordinates(params[:dest])
    @route = RoutingHelper.calculate_route(@start, @destination) if @start.present? && @destination.present?

    @target = params[:target]
  end
end
