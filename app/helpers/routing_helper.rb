require 'httparty'
require 'json'

module RoutingHelper
  def self.format_seconds_as_minsec(sec)
    format("%<minutes>.2d:%<seconds>.2d", minutes: sec / 60, seconds: sec % 60)
  end

  def self.building(input, max_indoor_dist)
    if (valid_coordinates?(input) || BuildingMapHelper.location?(input))
      (start_lat, start_long) = resolve_coordinates(input).split(',')
      coords = [start_lat.to_f, start_long.to_f]
      door = IndoorRoutingHelper.closest_door_node(coords, IndoorGraph::BUILDINGS, max_indoor_dist)
      return nil if door.nil?
      return door[:building]
    end
    if BuildingMapHelper.building?(input)
      return BuildingMapHelper.map_building_name_to_graph(input)
    end
    if BuildingMapHelper.room?(input)
      building_name = BuildingMapHelper.find_room(input).building.name
      return BuildingMapHelper.map_building_name_to_graph(building_name)
    end
    return nil
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
