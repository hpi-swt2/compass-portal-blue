class BuildingMapController < ApplicationController
  def index
    @start = RoutingHelper.valid_coordinates(params[:start]) ? params[:start] : nil
    @destination = RoutingHelper.valid_coordinates(params[:dest]) ? params[:dest] : nil
    @route = @start.present? && @destination.present? ? RoutingHelper.calculate_route(@start, @destination) : nil
  end
end
