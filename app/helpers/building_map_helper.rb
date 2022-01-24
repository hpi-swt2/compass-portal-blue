module BuildingMapHelper
  def self.leaflet_center
    {
      latlng: %w[52.39339 13.13208],
      zoom: 17
    }
  end

  def self.leaflet_polygons
    Buildings.transform_leaflet_buildings(Buildings::UNIPOTSDAM_POLYONGS, Buildings::UNIPOTSDAM_STYLING) +
      Buildings.transform_leaflet_buildings(Buildings::HPI_POLYGONS, Buildings::HPI_STYLING)
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
