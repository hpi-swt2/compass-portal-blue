module IndoorGraph
    INDOOR_GRAPHS = Hash.new
    DOOR_NODES = Hash.new
    def self.load_graphs(buildings)
        buildings.each {|building| 
            INDOOR_GRAPHS.merge!(building => JSON.parse(File.read('./app/assets/graphs/' << building << ".json")))
            DOOR_NODES.merge!(building => INDOOR_GRAPHS[building].select { |key, node| node['door']}.map {|key, value| key})
        }
        INDOOR_GRAPHS.freeze
        DOOR_NODES.freeze
    end
end