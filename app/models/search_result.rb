# One singular item for display in a list of search results
class SearchResult
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id, :title, :description, :link, :resource, :type, :location_longitude, :location_latitude

  validates :id, :title, :link, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def position_set?
    !(location_latitude.nil? || location_longitude.nil?)
  end
end
