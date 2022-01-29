module IndoorGraph
  INDOOR_GRAPHS = {}
  DOOR_NODES = {}
  NODES = {}
  ENTRY_NODES = {}
  BUILDINGS = ["HausABC"].freeze

  def self.load_graphs
    BUILDINGS.each { |building|
      INDOOR_GRAPHS[building] = JSON.parse(File.read('./app/assets/graphs/' << building << ".json"))
      DOOR_NODES[building] = INDOOR_GRAPHS[building].select { |_key, node| node['door'] }.map { |key, _value| key }
      ENTRY_NODES[building] = INDOOR_GRAPHS[building].select { |_key, node| node['entry'] }.map { |key, _value| key }
      NODES.merge!(building => INDOOR_GRAPHS[building].map { |key, _value| key})
    }
    INDOOR_GRAPHS.freeze
    DOOR_NODES.freeze
    ENTRY_NODES.freeze
    NODES.freeze
  end
end
