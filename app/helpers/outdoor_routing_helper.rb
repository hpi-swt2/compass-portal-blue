require 'httparty'
require 'json'

module OutdoorRoutingHelper
  def self.routing_url(start, dest)
    "http://routing.openstreetmap.de/routed-foot/route/v1/driving/#{start[1]},#{start[0]};#{dest[1]},#{dest[0]}?overview=full&geometries=geojson"
  end

  def self.handle_outdoor_indoor_case(start, dest_building, res)
    entrance = RoutingHelper.best_entry(dest_building[:building], start)
    route_outdoor(entrance[:latlng], start, res)
    IndoorRoutingHelper.route_indoor(dest_building[:door], entrance[:id], dest_building[:building], res)
  end

  def self.calculate_route(start, destination)
    response = HTTParty.get(routing_url(start, destination))
    return unless response.code == 200 # OPTIMIZE: give User feedback

    JSON.parse(response.body)["routes"][0]
  rescue StandardError
    # OPTIMIZE: give User feedback
  end

  def self.route_outdoor(start, dest, res)
    result = OutdoorRoutingHelper.calculate_route(start, dest)
    res[:polylines].concat([{
                             floor: 0,
                             indoor: false,
                             polyline: OutdoorRoutingHelper.transform_route_to_polyline(result)
                           }])
    res[:walktime] += result["duration"]
    res
  end

  def self.transform_route_to_polyline(route)
    route["geometry"]["coordinates"].map do |(long, lat)|
      [lat, long]
    end
  end
end
