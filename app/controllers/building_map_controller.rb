class BuildingMapController < ApplicationController
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze # TODO: This is currenty hard coded in the building_map.js file

  def index; end

  def buildings
    polygons = BuildingMapHelper.leaflet_polygons
    respond_to do |format|
      format.json { render json: polygons }
    end
  end

  def view
    view = BuildingMapHelper.leaflet_center
    respond_to do |format|
      format.json { render json: view }
    end
  end

  def markers
    markers = Buildings.transform_leaflet_letters(Buildings::HPI_LETTERS)
    respond_to do |format|
      format.json { render json: markers }
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
