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

    start_building = RoutingHelper.room_building(params[:start], params[:start_floor].to_i, MAX_INDOOR_DIST) # nil if outside
    dest_building = RoutingHelper.room_building(params[:dest], params[:dest_floor].to_i, MAX_INDOOR_DIST)

    polylines = Array.new
    walktime = 0

    if !start_building[:indoor] && !dest_building[:indoor]
      result = OutdoorRoutingHelper.calculate_route(start, dest);
      polylines.concat([{
        :floor => 0,
        :polyline => OutdoorRoutingHelper.transform_route_to_polyline(result)
      }])
      walktime += result["duration"]
    else
      if start_building[:building] == dest_building[:building]
        result = IndoorRoutingHelper.calculate_route(start_building[:door], dest_building[:door], start_building[:building])
        polylines.concat(result[:polylines])
        puts 
        walktime += result[:walktime]
      end
    end
    start_pos = [start.split(',')[0], start.split(',')[1]]
    respond(polylines, start_pos, walktime);
  end

  def respond(polylines, start, walktime)
    result = { polylines: polylines,
               marker: RoutingHelper.routing_marker(start, walktime) }
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
