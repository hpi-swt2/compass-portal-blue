module IndoorGraph
    INDOOR_GRAPHS = Hash.new

    def self.load_graphs(buildings)
        buildings.each {|building| INDOOR_GRAPHS.merge!(building => JSON.parse(File.read('./app/assets/graphs/' << building << ".json")))}
        INDOOR_GRAPHS.freeze
    end
end