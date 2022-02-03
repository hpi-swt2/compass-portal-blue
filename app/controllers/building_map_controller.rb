class BuildingMapController < ApplicationController
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze # TODO: This is currenty hard coded in the building_map.js file
  PIN_1_MAGIC_STRING = "Pin 1".freeze
  PIN_2_MAGIC_STRING = "Pin 2".freeze

  def _index; end

  def view
    view = BuildingMapHelper.leaflet_center
    respond_to do |format|
      format.json { render json: view }
    end
  end

  def route
    start = RoutingHelper.resolve_coordinates(params[:start])
    dest = RoutingHelper.resolve_coordinates(params[:dest])
    route = RoutingHelper.calculate_route(start, dest) if start.present? && dest.present?

    result = { polyline: RoutingHelper.transform_route_to_polyline(route),
               marker: RoutingHelper.transform_route_to_time_marker(route) }
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
