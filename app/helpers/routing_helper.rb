require 'net/http'
require 'json'

module RoutingHelper
  def self.routes
    url = URI.parse('http://router.project-osrm.org/route/v1/foot/13.133082,52.393913;13.129606,52.393861?overview=full&geometries=geojson')
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
