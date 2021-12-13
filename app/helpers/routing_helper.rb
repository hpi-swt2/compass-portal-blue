require 'httparty'
require 'json'

module RoutingHelper
  def self.format_seconds_as_minsec(sec)
    format("%<minutes>.2d:%<seconds>.2d", minutes: sec / 60, seconds: sec % 60)
  end

  def self.coordinates(input, your_location)
    if input.blank? then return end
    if valid_coordinates?(input) then return input end
    if input == "Your location" then return your_location end
    place = Places::DESTINATIONS[:"#{input}"]
    result = nil
    if place.present? then result = place[:location] end
    result
  end

  def self.center(start_coordinates)
    if start_coordinates.nil? then return [52.39339, 13.13208] end
    return start_coordinates.split(",").map{|c| c.to_f}
  end

  def self.valid_coordinates?(coordinates)
    return false if coordinates.blank?

    regex = /^-?\d{1,2}(\.\d{1,8})?,-?\d{1,2}(\.\d{1,8})?$/
    coordinates.match(regex)
  end

  def self.routing_url(start, destination)
    (start_lat, start_long) = start.split(",")
    (dest_lat, dest_long) = destination.split(",")
    "http://routing.openstreetmap.de/routed-foot/route/v1/driving/#{start_long},#{start_lat};#{dest_long},#{dest_lat}?overview=full&geometries=geojson"
  end

  def self.calculate_route(start, destination)
    return unless valid_coordinates?(start) && valid_coordinates?(destination)

    begin
      response = HTTParty.get(routing_url(start, destination))
      return unless response.code == 200 # OPTIMIZE: give User feedback

      JSON.parse(response.body)["routes"][0]
    rescue StandardError
      # OPTIMIZE: give User feedback
    end
  end

  def self.transform_route_to_time_marker(route)
    return [] unless route

    walking_time = format_seconds_as_minsec(route["duration"])
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
    return unless route

    coordinates = route["geometry"]["coordinates"].map do |(long, lat)|
      [lat, long]
    end
    { latlngs: coordinates, options: { className: "routing-path" } }
  end
end
