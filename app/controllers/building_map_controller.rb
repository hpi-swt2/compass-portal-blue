class BuildingMapController < ApplicationController
  def index
    @start = RoutingHelper.coordinates(params[:start], params[:your_location])
    @destination = RoutingHelper.coordinates(params[:dest], "")
    @route = RoutingHelper.calculate_route(@start, @destination) if @start.present? && @destination.present?
  end
end
