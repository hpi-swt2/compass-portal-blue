require 'algorithms'

module DijkstraHelper
  include Containers

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
      walktime: IndoorRoutingHelper.walk_time(nodes[dest][:prev] ? nodes[dest][:dist] : 0)
    }
  end

  def self.add_to_polylines(floor, color, polyline, polylines)
    polylines.push({ floor: floor, color: color, polyline: polyline })
  end

  def self.init_polylines(nodes, curr, graph, color)
    polylines = []
    last_latlng = []
    last_floor = graph[curr]['floor']
    add_to_polylines(last_floor, color, [graph[curr]['latlng']], polylines) unless nodes[curr][:prev].nil?
    [polylines, last_floor, last_latlng]
  end

  def self.retrieve_polylines(nodes, curr, graph, color)
    (polylines, last_floor, last_latlng) = init_polylines(nodes, curr, graph, color)
    until (curr = nodes[curr][:prev]).nil?
      if last_floor == graph[curr]['floor']
        polylines.last[:polyline].push(graph[curr]['latlng'])
      else
        add_to_polylines(graph[curr]['floor'], color, [last_latlng, graph[curr]['latlng']], polylines)
      end
      last_floor = graph[curr]['floor']
      last_latlng = graph[curr]['latlng']
    end
    polylines
  end
end
