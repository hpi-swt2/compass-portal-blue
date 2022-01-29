require 'httparty'
require 'json'

module RoutingHelper
  def self.format_seconds_as_minsec(sec)
    format("%<minutes>.2d:%<seconds>.2d", minutes: sec / 60, seconds: sec % 60)
  end

  def self.room_building(input, floor, max_indoor_dist)
    if valid_coordinates?(input) || BuildingMapHelper.location?(input)
      (start_lat, start_long) = resolve_coordinates(input).split(',')
      coords = [start_lat.to_f, start_long.to_f]
      door = IndoorRoutingHelper.closest_door_node(coords, IndoorGraph::BUILDINGS, max_indoor_dist, floor)
      return { indoor: false, building: nil, door: nil } if door.nil?

      return { indoor: true, building: door[:building], door: door[:door] }
    end
    if BuildingMapHelper.building?(input) # in this case we only use outside routing
      return { indoor: false, building: BuildingMapHelper.map_building_name_to_graph(input), door: nil }
    end

    if BuildingMapHelper.room?(input)
      building_name = BuildingMapHelper.find_room(input).building.name
      { indoor: true, building: BuildingMapHelper.map_building_name_to_graph(building_name), door: nil }
    end
  end

  def self.routing_marker(latlng, walkingtime)
    walkingtime = format_seconds_as_minsec(walkingtime)
    {
      latlng: latlng,
      divIcon: {
        html: walkingtime,
        className: "time-icon"
      }
    }
  end

  def self.resolve_coordinates(input)
    return input if valid_coordinates?(input)

    Rails.logger.debug 'destinations'
    Rails.logger.debug BuildingMapHelper.destinations
    BuildingMapHelper.destinations[input]
  end

  def self.valid_coordinates?(coordinates)
    return false if coordinates.blank?

    regex = /^-?\d{1,2}(\.\d+)?,-?\d{1,2}(\.\d+)?$/
    coordinates.match(regex)
  end
end
