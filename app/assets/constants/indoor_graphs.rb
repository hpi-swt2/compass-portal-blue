module IndoorGraph
  @indoor_graphs = {}
  @nodes = {}
  @entry_nodes = {}
  BUILDINGS = %w[HausABC HS H].freeze
  MAX_INDOOR_DIST = 10

  def self.load_building(building)
    @indoor_graphs[building] = JSON.parse(File.read('./app/assets/graphs/' << building << ".json"))
    @entry_nodes[building] = @indoor_graphs[building].select { |_key, node| node['entry'] }.map { |key, _value| key }
    @nodes.merge!(building => @indoor_graphs[building].map { |key, _value| key })
  end

  def self.load_graphs
    BUILDINGS.each { |building| load_building(building) }
    @entry_nodes.freeze
    @indoor_graphs.freeze
    @nodes.freeze
  end

  def self.nodes
    @nodes
  end

  def self.entry_nodes
    @entry_nodes
  end

  def self.indoor_graphs
    @indoor_graphs
  end
end
