require 'algorithms'
include Containers

module IndoorRoutingHelper
    
    def self.closest_door_node(latlng, buildings, maxDist)
        min = Float::MAX
        door = nil
        building = nil

        buildings.each {|b| 
            graph = IndoorGraph::INDOOR_GRAPHS[b]
            IndoorGraph::DOOR_NODES[b].each {|door_id|
                dist = distance(graph[door_id]["latlng"], latlng)
                if dist < min
                    min = dist
                    door = door_id
                    building = b
                end
            }
        }
        return nil if min > maxDist
        {
            door: door,
            distance: min,
            building: building,
        } 
    end

    def self.distance(latlng1, latlng2)
        dy = 111.3 * (latlng1[0] - latlng2[0])
        dx = 71.5 * (latlng1[1] - latlng2[1])
        Math.sqrt(dx * dx + dy * dy) * 1000
    end

    def self.calculate_route(from_id, to_id, building)
        puts "Debugging Output here:"
        graph = IndoorGraph::INDOOR_GRAPHS[building]
        start = graph[from_id]
        dest = graph[to_id]
        dijkstra(from_id, to_id, graph)
    end

    def self.dijkstra(start, dest, graph)
        q = PriorityQueue.new
        nodes = Hash.new
        graph.each do |key, value|
            nodes.merge!(key => {:dist => Float::INFINITY, :prev => nil})
        end
        nodes[start][:dist] = 0
        q.push(start, 0)

        while(!q.empty?)
            v = q.pop
            break if v == dest
            graph[v]["adj"].each {|edge|
                u = edge["node"]
                weight = edge["weight"]
                if nodes[v][:dist] + weight < nodes[u][:dist]
                    nodes[u][:dist] = nodes[v][:dist] + weight
                    nodes[u][:prev] = v;
                    q.push(u, nodes[u][:dist])
                end
            }
        end
        path = []
        curr = dest
        path.push({:latlng => graph[curr]['latlng'], :floor => graph[curr]['floor']}) unless nodes[curr][:prev].nil?
        while (!nodes[curr][:prev].nil?)
            curr = nodes[curr][:prev]
            path.push({:latlng => graph[curr]['latlng'], :floor => graph[curr]['floor']})
        end
        {
            path: path,
            dist: nodes[dest][:prev]? nodes[dest][:dist] : -1
        }
    end
end