require 'net/http'
require 'json'

module RoutingHelper
  def self.routes
    url = URI.parse('http://router.project-osrm.org/route/v1/driving/52.383353,13.094673;52.397339,13.135604?overview=full&geometries=geojson')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    json_response = JSON.parse(res.body)
    [{ latlngs: json_response["routes"][0]["geometry"]["coordinates"] }]
  end
end
