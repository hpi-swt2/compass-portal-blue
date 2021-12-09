class BuildingMapController < ApplicationController
  def index
    @start = params[:start]
    @destination = params[:dest]
    @route = RoutingHelper.calculate_route(@start, @destination)
  end
end
