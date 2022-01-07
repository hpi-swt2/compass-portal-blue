class BuildingMapController < ApplicationController
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze

  def index
    @start = RoutingHelper.resolve_coordinates(params[:start])
    @destination = RoutingHelper.resolve_coordinates(params[:dest])
    @route = RoutingHelper.calculate_route(@start, @destination) if @start.present? && @destination.present?
    
    @target = params[:target]
  end

  def buildings
    polygons = BuildingMapHelper.leaflet_polygons.to_json
    respond_to do |format|
      format.json { render json: polygons }
    end
  end

  def view
    start = RoutingHelper.resolve_coordinates(params[:start])
    view = BuildingMapHelper.leaflet_center(@start).to_json
    respond_to do |format|
      format.json { render json: view }
    end
  end

  def markers
    markers = Buildings.transform_leaflet_letters(Buildings::HPI_LETTERS).to_json
    respond_to do |format|
      format.json { render json: markers }
    end
  end

  def route(start, dest)
    parsedStart = RoutingHelper.resolve_coordinates(start)
    parsedDestination = RoutingHelper.resolve_coordinates(dest)
    route = RoutingHelper.calculate_route(parsedStart, parsedDestination) if parsedStart.present? && parsedDestination.present?
    respond_to do |format|
      format.json { render json: @route }
    end
  end
  
end
