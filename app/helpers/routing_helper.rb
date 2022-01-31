require 'httparty'
require 'json'

module RoutingHelper
  def self.format_seconds_as_minsec(sec)
    format("%<minutes>.2d:%<seconds>.2d", minutes: sec / 60, seconds: sec % 60)
  end

  def self.room_building(input, floor, max_indoor_dist)
    if valid_coordinates?(input) || BuildingMapHelper.location?(input)
      return room_building_from_coords(input, floor, max_indoor_dist)
    end
    if BuildingMapHelper.building?(input) # in this case we only use outside routing
      return { indoor: false, building: BuildingMapHelper.map_building_name_to_graph(input), door: nil }
    end

    return { indoor: false, building: nil, door: nil } unless BuildingMapHelper.room?(input)

    building_name = BuildingMapHelper.find_room(input).building.name
    { indoor: true, building: BuildingMapHelper.map_building_name_to_graph(building_name), door: nil }
  end

  def self.room_building_from_coords(input, floor, max_indoor_dist)
    (start_lat, start_long) = resolve_coordinates(input).split(',')
    coords = [start_lat.to_f, start_long.to_f]
    door = IndoorRoutingHelper.closest_door_node(coords, IndoorGraph::BUILDINGS, max_indoor_dist, floor)
    return { indoor: false, building: nil, door: nil } if door.nil?

    { indoor: true, building: door[:building], door: door[:door] }
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

  def self.coordinates_from_string(latlng_string)
    [latlng_string.split(',')[0].to_f, latlng_string.split(',')[1].to_f]
  end

  def self.best_entry(building, latlng)
    entry_id = nil
    min_dist = Float::MAX
    IndoorGraph::ENTRY_NODES[building].each do |id|
      distance = distance(IndoorGraph::INDOOR_GRAPHS[building][id]['latlng'], latlng)
      if distance < min_dist
        entry_id = id
        min_dist = distance
      end
    end
    { id: entry_id, latlng: IndoorGraph::INDOOR_GRAPHS[building][entry_id]['latlng'] }
  end

  def self.distance(latlng1, latlng2)
    dy = 111.3 * (latlng1[0] - latlng2[0])
    dx = 71.5 * (latlng1[1] - latlng2[1])
    Math.sqrt((dx * dx) + (dy * dy)) * 1000
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
