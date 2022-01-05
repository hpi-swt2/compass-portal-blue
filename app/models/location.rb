class Location < ApplicationRecord
  include Timeable

  validates :name, :location_longitude, :location_latitude, presence: true
  
  has_one_attached :location_photo
  accepts_nested_attributes_for :openingtimes, allow_destroy: true

  def self.location_photo()  
      location.location_photo.attach(
        io: File.open('app/assets/images/default-location-photo.png'),
        filename: 'default-location-photo.png',
        content_type: 'image/png'
      )
  end
end