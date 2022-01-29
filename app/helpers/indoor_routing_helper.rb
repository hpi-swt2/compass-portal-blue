require 'algorithms'
include Containers

module IndoorRoutingHelper
  def self.closest_door_node(latlng, buildings, maxDist, level)
    min = Float::MAX
    door = nil
    building = nil

    buildings.each {|b|
      graph = IndoorGraph::INDOOR_GRAPHS[b]
      IndoorGraph::NODES[b].each {|door_id|
        next unless graph[door_id]["floor"] == level

        dist = distance(graph[door_id]["latlng"], latlng)
        next unless dist < min

        min = dist
        door = door_id
        building = b
      }
    }
    return nil if min > maxDist

    {
      door: door,
      distance: min,
      building: building
    }
  end

  def self.entries(building)
    IndoorGraph::ENTRY_NODES[building].map {|key| { id: key, latlng: IndoorGraph::INDOOR_GRAPHS[building][key]['latlng'] }}
  end

  def self.distance(latlng1, latlng2)
    dy = 111.3 * (latlng1[0] - latlng2[0])
    dx = 71.5 * (latlng1[1] - latlng2[1])
    Math.sqrt((dx * dx) + (dy * dy)) * 1000
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

      graph[v]["adj"].each {|edge|
        u = edge["node"]
        weight = edge["weight"]
        next unless nodes[v][:dist] + weight < nodes[u][:dist]

        nodes[u][:dist] = nodes[v][:dist] + weight
        nodes[u][:prev] = v;
        q.push(u, -1 * nodes[u][:dist]) # negative because the queue pops highest weight
      }
    end
    polylines = []
    curr = dest
    color = '#000000'
    last_floor = graph[curr]['floor']
    polylines.push({
                     floor: last_floor,
                     color: color,
                     polyline: [graph[curr]['latlng']]
                   }) unless nodes[curr][:prev].nil?

    until nodes[curr][:prev].nil?
      curr = nodes[curr][:prev]
      current_floor = graph[curr]['floor']
      if last_floor == graph[curr]['floor']
        polylines.last[:polyline].push(graph[curr]['latlng'])
      else
        last_floor = current_floor
        polylines.push({
                         floor: last_floor,
                         color: color,
                         polyline: [graph[curr]['latlng']]
                       })
      end
    end
    {
      polylines: polylines,
      walktime: walk_time(nodes[dest][:prev] ? nodes[dest][:dist] : Float::MAX)
    }
  end

  def self.walk_time(dist)
    dist / 1.38889
  end
end
