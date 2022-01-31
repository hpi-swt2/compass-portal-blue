class BuildingMapController < ApplicationController
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze # TODO: This is currenty hard coded in the building_map.js file
  PIN_1_MAGIC_STRING = "Pin 1".freeze
  PIN_2_MAGIC_STRING = "Pin 2".freeze
  MAX_INDOOR_DIST = 10

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

    start = RoutingHelper.coordinates_from_string(RoutingHelper.resolve_coordinates(params[:start]))
    dest = RoutingHelper.coordinates_from_string(RoutingHelper.resolve_coordinates(params[:dest]))

    start_building = RoutingHelper.room_building(params[:start], params[:start_floor].to_i, MAX_INDOOR_DIST) # nil if outside
    dest_building = RoutingHelper.room_building(params[:dest], params[:dest_floor].to_i, MAX_INDOOR_DIST)

    polylines = []
    walktime = 0

    if !start_building[:indoor] && !dest_building[:indoor] # outdoor - outdoor
      result = OutdoorRoutingHelper.calculate_route(start, dest)
      polylines.concat([{
                         floor: 0,
                         color: '#346eeb',
                         polyline: OutdoorRoutingHelper.transform_route_to_polyline(result)
                       }])
      walktime += result["duration"]
    elsif start_building[:indoor]
      if start_building[:building] == dest_building[:building] # Indoor same building
        result = IndoorRoutingHelper.calculate_route(start_building[:door], dest_building[:door],
                                                     start_building[:building])
        polylines.concat(result[:polylines])
        walktime += result[:walktime]
      elsif !dest_building[:indoor] # indoor to outdoor
        exit_door = RoutingHelper.best_entry(start_building[:building], dest)
        result = IndoorRoutingHelper.calculate_route(start_building[:door], exit_door[:id], start_building[:building])
        polylines.concat(result[:polylines])
        walktime += result[:walktime]
        result = OutdoorRoutingHelper.calculate_route(exit_door[:latlng], dest)
        polylines.concat([{
                           floor: 0,
                           color: '#346eeb',
                           polyline: OutdoorRoutingHelper.transform_route_to_polyline(result)
                         }])
        walktime += result["duration"]
      else # Indoor -> Indoor (other building)
        # Leave first building
        exit_door = RoutingHelper.best_entry(start_building[:building], dest)
        result = IndoorRoutingHelper.calculate_route(start_building[:door], exit_door[:id], start_building[:building])
        polylines.concat(result[:polylines])
        walktime += result[:walktime]
        # Go to 2nd building
        entrance = RoutingHelper.best_entry(dest_building[:building], exit_door[:latlng])
        result = OutdoorRoutingHelper.calculate_route(exit_door[:latlng], entrance[:latlng])
        polylines.concat([{
                           floor: 0,
                           color: '#346eeb',
                           polyline: OutdoorRoutingHelper.transform_route_to_polyline(result)
                         }])
        walktime += result["duration"]
        # In 2nd building
        result = IndoorRoutingHelper.calculate_route(entrance[:id], dest_building[:door], dest_building[:building])
        polylines.concat(result[:polylines])
        walktime += result[:walktime]
      end
    else # outdoor -> indoor
      entrance = RoutingHelper.best_entry(dest_building[:building], start)
      result = IndoorRoutingHelper.calculate_route(dest_building[:door], entrance[:id], dest_building[:building])
      polylines.concat(result[:polylines])
      walktime += result[:walktime]
      result = OutdoorRoutingHelper.calculate_route(entrance[:latlng], start)
      polylines.concat([{
                         floor: 0,
                         color: '#346eeb',
                         polyline: OutdoorRoutingHelper.transform_route_to_polyline(result)
                       }])
      walktime += result["duration"]
    end
    respond(polylines, start, walktime)
  end

  def respond(polylines, start, walktime)
    result = { polylines: polylines,
               marker: RoutingHelper.routing_marker(start, walktime) }
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
