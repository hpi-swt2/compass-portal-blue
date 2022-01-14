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
end
