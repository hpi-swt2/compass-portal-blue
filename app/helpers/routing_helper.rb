require 'net/http'
require 'json'

module RoutingHelper
  def self.calculate_route(start, destination)
    if !(start.present? && destination.present?) # No route requested
      return {}
    end
    # The API request lat and long to be swapped.
    startLocation = start.split(",")
    destLocation = destination.split(",")
    url = URI.parse("http://router.project-osrm.org/route/v1/foot/#{startLocation[1]},#{startLocation[0]};#{destLocation[1]},#{destLocation[0]}?overview=full&geometries=geojson")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    json_response = JSON.parse(res.body)
    coordinates = json_response["routes"][0]["geometry"]["coordinates"].map do |coordinate|
      [coordinate.second, coordinate.first]
    end
    [{ latlngs: coordinates }]
  end
end
