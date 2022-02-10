module IndoorGraph
  @indoor_graphs = {}
  @nodes = {}
  @entry_nodes = {}
  BUILDINGS = %w[ABC HS H G].freeze
  MAX_INDOOR_DIST = 10

  # rubocop:disable Metrics/AbcSize
  def self.load_building(building)
    # file_name = ActionController::Base.helpers.asset_path(building << ".json")
    file_name = "./app/assets/graphs/" << building << ".json" # FIXME: Adapt assets path
    indoor_graphs[building] = JSON.parse(File.read(file_name))
    entry_nodes[building] = indoor_graphs[building].select { |_key, node| node['entry'] }.keys
    nodes.merge!(building => indoor_graphs[building].keys)
  end
  # rubocop:enable Metrics/AbcSize

  def self.load_graphs
    BUILDINGS.each { |building| load_building(building) }
    entry_nodes.freeze
    indoor_graphs.freeze
    nodes.freeze
  end

  class << self
    attr_accessor :nodes, :entry_nodes, :indoor_graphs
  end
end
