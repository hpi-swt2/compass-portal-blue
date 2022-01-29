module IndoorGraph
    INDOOR_GRAPHS = Hash.new
    DOOR_NODES = Hash.new
    NODES = Hash.new
    ENTRY_NODES = Hash.new
    BUILDINGS = ["HausABC"].freeze

    def self.load_graphs()
        BUILDINGS.each {|building| 
            INDOOR_GRAPHS.merge!(building => JSON.parse(File.read('./app/assets/graphs/' << building << ".json")))
            DOOR_NODES.merge!(building => INDOOR_GRAPHS[building].select { |key, node| node['door']}.map {|key, value| key})
            ENTRY_NODES.merge!(building => INDOOR_GRAPHS[building].select { |key, node| node['entry']}.map {|key, value| key})
            NODES.merge!(building => INDOOR_GRAPHS[building].map {|key, value| key})
        }
        INDOOR_GRAPHS.freeze
        DOOR_NODES.freeze
        ENTRY_NODES.freeze
        NODES.freeze
    end
end