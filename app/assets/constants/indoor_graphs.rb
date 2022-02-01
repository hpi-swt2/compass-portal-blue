module IndoorGraph
  INDOOR_GRAPHS = {}
  NODES = {}
  ENTRY_NODES = {}
  BUILDINGS = ["HausABC", "Hörsaalgebäude"].freeze

  def self.load_graphs
    BUILDINGS.each { |building|
      INDOOR_GRAPHS[building] = JSON.parse(File.read('./app/assets/graphs/' << building << ".json"))
      ENTRY_NODES[building] = INDOOR_GRAPHS[building].select { |_key, node| node['entry'] }.map { |key, _value| key }
      NODES.merge!(building => INDOOR_GRAPHS[building].map { |key, _value| key })
    }
    INDOOR_GRAPHS.freeze
    ENTRY_NODES.freeze
    NODES.freeze
  end
end
