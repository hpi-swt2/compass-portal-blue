require 'httparty'
require 'json'

module OutdoorRoutingHelper
  def self.routing_url(start, destination)
    (start_lat, start_long) = start.split(",")
    (dest_lat, dest_long) = destination.split(",")
    "http://routing.openstreetmap.de/routed-foot/route/v1/driving/#{start_long},#{start_lat};#{dest_long},#{dest_lat}?overview=full&geometries=geojson"
  end

  def self.calculate_route(start, destination)
    begin
      response = HTTParty.get(routing_url(start, destination))
      return unless response.code == 200 # OPTIMIZE: give User feedback

      JSON.parse(response.body)["routes"][0]
    rescue StandardError
      # OPTIMIZE: give User feedback
    end
  end

  def self.transform_route_to_polyline(route)
    coordinates = route["geometry"]["coordinates"].map do |(long, lat)|
      [lat, long]
    end
  end
end