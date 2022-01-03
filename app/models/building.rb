class Building < ApplicationRecord
  include Timeable
  validates :name, presence: true
  validates :location_latitude, \
            presence: true, \
            numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :location_longitude, \
            presence: true, \
            numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
