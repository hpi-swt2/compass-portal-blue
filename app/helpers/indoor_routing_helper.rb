require 'algorithms'

module IndoorRoutingHelper
  include Containers

  def self.closest_door_node(latlng, buildings, max_dist, level)
    min = Float::MAX
    door = nil
    building = nil

    buildings.each do |b|
      graph = IndoorGraph::INDOOR_GRAPHS[b]
      IndoorGraph::NODES[b].each do |door_id|
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
    IndoorGraph::ENTRY_NODES[building].map do |key|
      { id: key, latlng: IndoorGraph::INDOOR_GRAPHS[building][key]['latlng'] }
    end
  end

  def self.calculate_route(from_id, to_id, building)
    Rails.logger.debug "Debugging Output here:"
    graph = IndoorGraph::INDOOR_GRAPHS[building]
    dijkstra(from_id, to_id, graph)
  end

  def self.dijkstra(start, dest, graph)
    q = PriorityQueue.new
    nodes = {}
    graph.each do |key, _value|
      nodes.merge!(key => { dist: Float::INFINITY, prev: nil })
    end
    nodes[start][:dist] = 0
    q.push(start, 0)

    until q.empty?
      v = q.pop
      break if v == dest

      graph[v]["adj"].each do |edge|
        u = edge["node"]
        weight = edge["weight"]
        next unless nodes[v][:dist] + weight < nodes[u][:dist]

        nodes[u][:dist] = nodes[v][:dist] + weight
        nodes[u][:prev] = v
        q.push(u, -1 * nodes[u][:dist]) # negative because the queue pops highest weight
      end
    end
    {
      polylines: retrieve_polylines(nodes, dest, graph, '#000000'),
      walktime: walk_time(nodes[dest][:prev] ? nodes[dest][:dist] : Float::MAX)
    }
  end

  def self.retrieve_polylines(nodes, curr, graph, color)
    polylines = []
    last_floor = graph[curr]['floor']
    unless nodes[curr][:prev].nil?
      polylines.push({
                       floor: last_floor,
                       color: color,
                       polyline: [graph[curr]['latlng']]
                     })
    end

    last_latlng = []
    until nodes[curr][:prev].nil?
      curr = nodes[curr][:prev]
      current_floor = graph[curr]['floor']
      if last_floor == current_floor
        last_latlng = graph[curr]['latlng']
        polylines.last[:polyline].push(last_latlng)
      else
        last_floor = current_floor
        polylines.push({
                         floor: last_floor,
                         color: color,
                         polyline: [last_latlng, graph[curr]['latlng']]
                       })
        last_latlng = graph[curr]['latlng']
      end
    end
    polylines
  end

  def self.walk_time(dist)
    dist / 1.38889
  end
end
