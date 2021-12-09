require 'httparty'
require 'json'

module RoutingHelper
  def self.seconds_to_minsec(sec)
    format("%<minutes>.2d:%<seconds>.2d", minutes: sec / 60, seconds: sec % 60)
  end

  def self.valid_coordinates(coordinates)
    return false if coordinates.blank?

    regex = /^[0-9]{1,2}(\.[0-9]{1,6})?,[0-9]{1,2}(\.[0-9]{1,6})?$/
    coordinates.match(regex)
  end

  def self.calculate_route(start, destination)
    return nil unless valid_coordinates(start) && valid_coordinates(destination) # No route requested

    start_location = start.split(",")
    dest_location = destination.split(",")
    # The API requires long, lat instead of lat, long so we have to swap those
    begin
      response = HTTParty.get("http://routing.openstreetmap.de/routed-foot/route/v1/driving/#{start_location[1]},#{start_location[0]};#{dest_location[1]},#{dest_location[0]}?overview=full&geometries=geojson")
      return nil unless response.code == 200

      JSON.parse(response.body)["routes"][0]
    rescue StandardError
      nil
    end
  end

  def self.transform_route_to_time_marker(route)
    return [] unless route

    walking_time = seconds_to_minsec(route["duration"])
    start = route["geometry"]["coordinates"][0]
    [{
      latlng: [start.second, start.first],
      div_icon: {
        html: walking_time,
        class_name: "time-icon"
      }
    }]
  end

  def self.transform_route_to_polyline(route)
    return [] unless route

    coordinates = route["geometry"]["coordinates"].map do |coordinate|
      [coordinate.second, coordinate.first]
    end
    [{ latlngs: coordinates, options: { className: "routing-path" } }]
  end
end
