# the model representing a location of interest
class Location < ApplicationRecord
  include Timeable

  validates :name, presence: true
  validates :location_latitude, \
            presence: true, \
            numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :location_longitude, \
            presence: true, \
            numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  has_one_attached :location_photo
  accepts_nested_attributes_for :openingtimes, allow_destroy: true
end
