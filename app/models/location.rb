# the model representing a location of interest
class Location < ApplicationRecord
  has_and_belongs_to_many :owners, class_name: 'User', join_table: 'location_owner'
  include Timeable
  include Locateable

  validates :name, presence: true
  has_one_attached :location_photo
  accepts_nested_attributes_for :openingtimes, allow_destroy: true
end
