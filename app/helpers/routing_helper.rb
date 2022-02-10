require 'httparty'
require 'json'

module RoutingHelper
  def self.format_seconds_as_minsec(sec)
    format("%<minutes>.2d:%<seconds>.2d", minutes: sec / 60, seconds: sec % 60)
  end

  def self.calculate_route(start, dest, start_building, dest_building, res)
    if !start_building[:indoor] && !dest_building[:indoor] # outdoor - outdoor
      OutdoorRoutingHelper.route_outdoor(start, dest, res)
    elsif start_building[:indoor]
      handle_start_indoor_cases(dest, start_building, dest_building, res)
    else
      route_outdoor_indoor(start, dest_building, res)
    end
  end

  def self.init_routing(params)
    start = coordinates_from_string(resolve_coordinates(params[:start]))
    dest = coordinates_from_string(resolve_coordinates(params[:dest]))
    start_building = room_building(params[:start], params[:start_floor].to_i, IndoorGraph::MAX_INDOOR_DIST)
    dest_building = room_building(params[:dest], params[:dest_floor].to_i, IndoorGraph::MAX_INDOOR_DIST)
    res = { polylines: [], walktime: 0 }
    [start, dest, start_building, dest_building, res]
  end

  def self.handle_start_indoor_cases(dest, start_building, dest_building, res)
    exit_door = best_entry(start_building[:building], dest)
    if start_building[:building] == dest_building[:building] # Indoor same building
      IndoorRoutingHelper.route_indoor(start_building[:node], dest_building[:node], start_building[:building], res)
    elsif !dest_building[:indoor] # indoor to outdoor
      route_indoor_outdoor(start_building, dest, exit_door, res)
    else # Indoor -> Indoor (other building)
      route_indoor_outdoor_indoor(start_building, dest_building, exit_door, res)
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.room_building(input, floor, max_indoor_dist)
    if valid_coordinates?(input) || BuildingMapHelper.location?(input)
      return room_building_from_coords(input, floor, max_indoor_dist)
    end
    if BuildingMapHelper.building?(input) # in this case we only use outside routing
      return { indoor: false, building: BuildingMapHelper.map_building_name_to_graph(input), node: nil }
    end
    return { indoor: false, building: nil, node: nil } unless BuildingMapHelper.room?(input)

    room = Room.find_by(name: input)
    floor = room.floor
    node = IndoorRoutingHelper.closest_node([room.location_latitude, room.location_longitude],
                                            IndoorGraph::BUILDINGS, max_indoor_dist, floor)
    { indoor: true, building: door[:building], node: node[:node] }
  end
  # rubocop:enable Metrics/MethodLength

  def self.room_building_from_coords(input, floor, max_indoor_dist)
    coords = coordinates_from_string(resolve_coordinates(input))
    node = IndoorRoutingHelper.closest_node(coords, IndoorGraph::BUILDINGS, max_indoor_dist, floor)
    return { indoor: false, building: nil, node: nil } if node.nil?

    { indoor: true, building: node[:building], node: node[:node] }
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
    IndoorGraph.entry_nodes[building].each do |id|
      distance = distance(IndoorGraph.indoor_graphs[building][id]['latlng'], latlng)
      if distance < min_dist
        entry_id = id
        min_dist = distance
      end
    end
    { id: entry_id, latlng: IndoorGraph.indoor_graphs[building][entry_id]['latlng'] }
  end

  def self.distance(latlng1, latlng2)
    dy = 111.3 * (latlng1[0] - latlng2[0])
    dx = 71.5 * (latlng1[1] - latlng2[1])
    Math.sqrt((dx * dx) + (dy * dy)) * 1000
  end

  def self.resolve_coordinates(input)
    return input if valid_coordinates?(input)

    BuildingMapHelper.destinations[input]
  end

  def self.route_outdoor_indoor(start, dest_building, res)
    entrance = RoutingHelper.best_entry(dest_building[:building], start)
    OutdoorRoutingHelper.route_outdoor(entrance[:latlng], start, res)
    IndoorRoutingHelper.route_indoor(dest_building[:node], entrance[:id], dest_building[:building], res)
  end

  def self.route_indoor_outdoor(start_building, dest, exit_door, res)
    IndoorRoutingHelper.route_indoor(start_building[:node], exit_door[:id], start_building[:building], res)
    OutdoorRoutingHelper.route_outdoor(exit_door[:latlng], dest, res)
  end

  def self.route_indoor_outdoor_indoor(start_building, dest_building, exit_door, res)
    entry_door = RoutingHelper.best_entry(dest_building[:building], exit_door[:latlng])
    IndoorRoutingHelper.route_indoor(start_building[:node], exit_door[:id], start_building[:building], res)
    OutdoorRoutingHelper.route_outdoor(exit_door[:latlng], entry_door[:latlng], res)
    IndoorRoutingHelper.route_indoor(entry_door[:id], dest_building[:node], dest_building[:building], res)
  end

  def self.valid_coordinates?(coordinates)
    return false if coordinates.blank?

    regex = /^-?\d{1,2}(\.\d+)?,-?\d{1,2}(\.\d+)?$/
    coordinates.match(regex)
  end
end
