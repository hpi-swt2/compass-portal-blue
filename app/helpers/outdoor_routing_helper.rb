require 'httparty'
require 'json'

module OutdoorRoutingHelper
  def self.routing_url(start, dest)
    "http://routing.openstreetmap.de/routed-foot/route/v1/driving/#{start[1]},#{start[0]};#{dest[1]},#{dest[0]}?overview=full&geometries=geojson"
  end

  def self.calculate_route(start, destination)
    response = HTTParty.get(routing_url(start, destination))
    return unless response.code == 200 # OPTIMIZE: give User feedback

    JSON.parse(response.body)["routes"][0]
  rescue StandardError
    # OPTIMIZE: give User feedback
  end

  def self.route_outdoor(start, dest, map_data)
    result = calculate_route(start, dest)
    # Hint: If you are getting 500ish errors here, it may be because you tried
    # to test routing from or to the coordinates "0,0", which OSM rejects,
    # pointing out that you sent a meaningless query - `result` is `nil` then.
    map_data[:polylines].concat([
                                  {
                                    floor: 0,
                                    indoor: false,
                                    polyline: transform_route_to_polyline(result)
                                  }
                                ])
    map_data[:walktime] += result["duration"]
    map_data
  end

  def self.transform_route_to_polyline(route)
    route["geometry"]["coordinates"].map do |(long, lat)|
      [lat, long]
    end
  end
end
