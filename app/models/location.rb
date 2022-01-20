# the model representing a location of interest
class Location < ApplicationRecord
  include Timeable
  include Locateable

  validates :name, presence: true
  has_one_attached :location_photo
  accepts_nested_attributes_for :openingtimes, allow_destroy: true
end
