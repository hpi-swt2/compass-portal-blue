class BuildingMapController < ApplicationController
  # TODO: This is currenty hard coded in the constants.js file
  YOUR_LOCATION_MAGIC_STRING = "Your location".freeze
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
    return unless params[:start].present? && params[:dest].present?

    (start, dest, start_building, dest_building, res) = RoutingHelper.init_routing(params)
    RoutingHelper.calculate_route(start, dest, start_building, dest_building, res)
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
