module IndoorRoutingHelper
  def self.closest_door_node(latlng, buildings, max_dist, level)
    min = Float::MAX
    door = nil
    building = nil
    buildings.each do |b|
      graph = IndoorGraph.indoor_graphs[b]
      IndoorGraph.nodes[b].each do |door_id|
        next unless graph[door_id]["floor"] == level

        dist = RoutingHelper.distance(graph[door_id]["latlng"], latlng)
        next unless dist < min

        min = dist
        door = door_id
        building = b
      end
    end
    return nil if min > max_dist

    {
      door: door,
      distance: min,
      building: building
    }
  end

  def self.entries(building)
    IndoorGraph.entry_nodes[building].map do |key|
      { id: key, latlng: IndoorGraph.indoor_graphs[building][key]['latlng'] }
    end
  end

  def self.calculate_route(from_id, to_id, building)
    Rails.logger.debug "Debugging Output here:"
    graph = IndoorGraph.indoor_graphs[building]
    DijkstraHelper.dijkstra(from_id, to_id, graph)
  end

  def self.route_indoor(start, dest, building, res)
    result = IndoorRoutingHelper.calculate_route(start, dest, building)
    res[:polylines].concat(result[:polylines])
    res[:walktime] += result[:walktime]
    res
  end

  def self.route_indoor_outdoor(start_building, dest, exit_door, res)
    route_indoor(start_building[:door], exit_door[:id], start_building[:building], res)
    OutdoorRoutingHelper.route_outdoor(exit_door[:latlng], dest, res)
  end

  def self.route_indoor_outdoor_indoor(start_building, dest_building, exit_door, res)
    entry_door = RoutingHelper.best_entry(dest_building[:building], exit_door[:latlng])
    route_indoor(start_building[:door], exit_door[:id], start_building[:building], res)
    OutdoorRoutingHelper.route_outdoor(exit_door[:latlng], entry_door[:latlng], res)
    route_indoor(entry_door[:id], dest_building[:door], dest_building[:building], res)
  end

  def self.walk_time(dist)
    dist / 1.38889
  end
end
