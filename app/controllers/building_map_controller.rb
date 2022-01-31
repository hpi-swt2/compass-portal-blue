class BuildingMapController < ApplicationController
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze # TODO: This is currenty hard coded in the building_map.js file
  PIN_1_MAGIC_STRING = "Pin 1".freeze
  PIN_2_MAGIC_STRING = "Pin 2".freeze

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

    (start, dest, start_building, dest_building, res) = RoutingHelper.init_routing(params)

    if !start_building[:indoor] && !dest_building[:indoor] # outdoor - outdoor
      RoutingHelper.route_outdoor(start, dest, res)
    elsif start_building[:indoor]
      RoutingHelper.handle_start_indoor_cases(dest, start_building, dest_building, res)
    else
      entrance = RoutingHelper.best_entry(dest_building[:building], start)
      RoutingHelper.route_indoor(dest_building[:door], entrance[:id], dest_building[:building], res)
      RoutingHelper.route_outdoor(entrance[:latlng], start, res)
    end
    respond(res[:polylines], start, res[:walktime])
  end

  def respond(polylines, start, walktime)
    result = { polylines: polylines,
               marker: RoutingHelper.routing_marker(start, walktime) }
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
