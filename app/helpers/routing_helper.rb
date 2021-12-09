require 'net/http'
require 'json'

module RoutingHelper
  def self.seconds_to_minsec(sec)
    format("%02d:%02d", sec / 60 % 60, sec % 60)
  end

  def self.valid_coordinates(coordinates)
    return false if coordinates.blank?

    regex = /^[0-9]{1,2}\.[0-9]{1,6},[0-9]{1,2}\.[0-9]{1,6}$/
    coordinates.match(regex)
  end

  def self.calculate_route(start, destination)
    return nil unless self.valid_coordinates(start) && self.valid_coordinates(destination) # No route requested

    # The API request lat and long to be swapped.
    start_location = start.split(",")
    dest_location = destination.split(",")
    url = URI.parse("http://router.project-osrm.org/route/v1/foot/#{start_location[1]},#{start_location[0]};#{dest_location[1]},#{dest_location[0]}?overview=full&geometries=geojson")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    json_response = JSON.parse(res.body)
    json_response["routes"][0]
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
