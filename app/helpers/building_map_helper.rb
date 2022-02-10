module BuildingMapHelper
  def self.leaflet_center
    {
      latlng: %w[52.39339 13.13208],
      zoom: 17
    }
  end

  def self.destinations
    buildings = Building.all.to_h do |building|
      [ building.name, "#{building.location_latitude},#{building.location_longitude}" ]
    end
    locations = Location.all.to_h do |location|
      [ location.name, "#{location.location_latitude},#{location.location_longitude}" ]
    end
    buildings.merge(locations)
  end
end
