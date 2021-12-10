class BuildingMapController < ApplicationController
  def index
    @start = RoutingHelper.valid_coordinates(params[:start]) ? params[:start] : nil
    @destination = RoutingHelper.valid_coordinates(params[:dest]) ? params[:dest] : nil
    @route = (@start.present? && @destination.present?)? RoutingHelper.calculate_route(@start, @destination) : nil
    @polygons = Buildings.transform_leaflet_buildings(Buildings::UNIPOTSDAM_POLYONGS, Buildings::UNIPOTSDAM_STYLING)+
      (Buildings.transform_leaflet_buildings(Buildings::HPI_POLYGONS, Buildings::HPI_STYLING))
    @polylines = @route.present? ? [RoutingHelper.transform_route_to_polyline(@route)] : []
    @markers = Buildings.transform_leaflet_letters(Buildings::HPI_LETTERS) + RoutingHelper.transform_route_to_time_marker(@route)
  end
end
