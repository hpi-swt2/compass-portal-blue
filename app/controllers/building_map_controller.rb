class BuildingMapController < ApplicationController
  def index
    @start = params[:start] if RoutingHelper.valid_coordinates?(params[:start])
    @destination = params[:dest] if RoutingHelper.valid_coordinates?(params[:dest])
    @route = RoutingHelper.calculate_route(@start, @destination) if @start.present? && @destination.present?
  end
end
