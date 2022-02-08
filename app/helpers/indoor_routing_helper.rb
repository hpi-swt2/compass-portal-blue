module IndoorRoutingHelper
  def self.update_nearest_node_result(door_id, dist, building, result)
    result[:door] = door_id
    result[:distance] = dist
    result[:building] = building
  end

  def self.find_nearest_node(latlng, buildings, level, result)
    buildings.each do |b|
      graph = IndoorGraph.indoor_graphs[b]
      IndoorGraph.nodes[b].each do |door_id|
        next unless graph[door_id]["floor"] == level

        dist = RoutingHelper.distance(graph[door_id]["latlng"], latlng)
        update_nearest_node_result(door_id, dist, b, result) if dist < result[:distance]
      end
    end
  end

  def self.closest_node(latlng, buildings, max_dist, level)
    result = { door: nil, distance: Float::MAX, building: nil }
    find_nearest_node(latlng, buildings, level, result)
    result if result[:distance] < max_dist
  end

  def self.calculate_route(from_id, to_id, building)
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
