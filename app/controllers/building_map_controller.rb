class BuildingMapController < ApplicationController
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze # TODO: This is currenty hard coded in the building_map.js file
  PIN_1_MAGIC_STRING = "Pin 1".freeze
  PIN_2_MAGIC_STRING = "Pin 2".freeze
  MAX_INDOOR_DIST = 10.freeze

  def _index; end

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
    return unless params[:start].present? && params[:dest].present?
    start = RoutingHelper.resolve_coordinates(params[:start])
    dest = RoutingHelper.resolve_coordinates(params[:dest])
    start_building = RoutingHelper.room_building(params[:start], MAX_INDOOR_DIST) # nil if outside
    dest_building = RoutingHelper.room_building(params[:dest], MAX_INDOOR_DIST)

    return outdoor_route(start, dest) if !start_building[:indoor] && !dest_building[:indoor]
    
    if start_building[:building] == dest_building[:building]
       # Fall: 2 indoor, gleiches Gebäude
       puts IndoorRoutingHelper.calculate_route(start_building[:door], dest_building[:door], start_building[:building])
    end

    if start_building[:building]
      # gather all entries
      if start_building[:indoor]
        # find door_node
      end
    end

    if dest_building[:building]
      # gather all entries
      if dest_building[:indoor]
        # find door_node
      end
    end


    # Fall 2: 1 indoor, 1 outdoor

    # Fall 3.2: 2 indoor, anderes Gebäude
  end

  def outdoor_route(start, dest)
    route = OutdoorRoutingHelper.calculate_route(start, dest)
    result = { polyline: OutdoorRoutingHelper.transform_route_to_polyline(route),
               marker: OutdoorRoutingHelper.transform_route_to_time_marker(route) }
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
