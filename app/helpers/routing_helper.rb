require 'net/http'
require 'json'

module RoutingHelper
  def self.seconds_to_minsec(sec)
    format("%02d:%02d", sec / 60 % 60, sec % 60)
  end

  def self.calculate_route(start, destination)
    return nil unless start.present? && destination.present? # No route requested

    regex = /^[0-9]{1,2}\.[0-9]{1,6},[0-9]{1,2}\.[0-9]{1,6}$/
    return nil unless start.match(regex) && destination.match(regex)

    # The API request lat and long to be swapped.
    startLocation = start.split(",")
    destLocation = destination.split(",")
    url = URI.parse("http://router.project-osrm.org/route/v1/foot/#{startLocation[1]},#{startLocation[0]};#{destLocation[1]},#{destLocation[0]}?overview=full&geometries=geojson")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    json_response = JSON.parse(res.body)
    json_response["routes"][0]
  end

  def self.transform_route_to_time_marker(route)
    return [] unless route

    walking_time = route["duration"]
    pretty_time = seconds_to_minsec(walking_time)
    start = route["geometry"]["coordinates"][0]
    [{
      latlng: [start.second, start.first],
      div_icon: {
        html: pretty_time,
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
