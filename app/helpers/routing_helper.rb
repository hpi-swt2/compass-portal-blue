require 'httparty'
require 'json'

module RoutingHelper
  def self.format_seconds_as_minsec(sec)
    format("%<minutes>.2d:%<seconds>.2d", minutes: sec / 60, seconds: sec % 60)
  end

  def self.indoor?(input, max_indoor_dist)
    if (valid_coordinates?(input) || BuildingMapHelper.location?(input))
      (start_lat, start_long) = resolve_coordinates(input).split(',')
      coords = [start_lat.to_f, start_long.to_f]
      return (not IndoorRoutingHelper.closest_door_node(coords, IndoorGraph::BUILDINGS, max_indoor_dist).nil?)
    end
    return false if BuildingMapHelper.building?(input)
    return true if BuildingMapHelper.room?(input)
    return false
  end

  def self.resolve_coordinates(input)
    return input if valid_coordinates?(input)

    BuildingMapHelper.destinations[input]
  end

  def self.valid_coordinates?(coordinates)
    return false if coordinates.blank?
    regex = /^-?\d{1,2}(\.\d+)?,-?\d{1,2}(\.\d+)?$/
    coordinates.match(regex)
  end
end
