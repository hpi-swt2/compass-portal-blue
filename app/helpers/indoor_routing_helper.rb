module IndoorRoutingHelper
  WALK_SPEED = 1.4 # m/s

  def self.update_nearest_node_result(node_id, dist, building, result)
    result[:node] = node_id
    result[:distance] = dist
    result[:building] = building
  end

  def self.find_nearest_node(latlng, buildings, level, result)
    buildings.each do |b|
      graph = IndoorGraph.indoor_graphs[b]
      IndoorGraph.nodes[b].each do |node_id|
        next unless graph[node_id]["floor"] == level

        dist = RoutingHelper.distance(graph[node_id]["latlng"], latlng)
        update_nearest_node_result(node_id, dist, b, result) if dist < result[:distance]
      end
    end
  end

  def self.closest_node(latlng, buildings, max_dist, level)
    result = { node: nil, distance: Float::MAX, building: nil }
    find_nearest_node(latlng, buildings, level, result)
    result if result[:distance] < max_dist
  end

  def self.calculate_route(from_id, to_id, building)
    DijkstraHelper.dijkstra(from_id, to_id, IndoorGraph.indoor_graphs[building])
  end

  def self.route_indoor(start, dest, building, map_data)
    result = calculate_route(start, dest, building)
    map_data[:polylines].concat(result[:polylines])
    map_data[:walktime] += result[:walktime]
    map_data
  end

  def self.walk_time(dist)
    dist / WALK_SPEED
  end
end
