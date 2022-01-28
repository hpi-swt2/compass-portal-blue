module BuildingMapHelper
  def self.leaflet_center
    {
      latlng: %w[52.39339 13.13208],
      zoom: 17
    }
  end

  def self.leaflet_polygons
    transform_leaflet_buildings(Buildings::UNIPOTSDAM_POLYGONS, Buildings::UNIPOTSDAM_STYLING) +
      transform_leaflet_buildings(Buildings::HPI_POLYGONS, Buildings::HPI_STYLING)
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

  def self.leaflet_letters
    Buildings::HPI_LETTERS.map do |hpi_letter|
      {
        latlng: hpi_letter[:coordinate],
        divIcon: {
          html: hpi_letter[:letter],
          className: "building-icon"
        }
      }
    end
  end

  def self.transform_leaflet_buildings(geometries, options)
    geometries.map do |polygon|
      {
        latlngs: polygon,
        options: options
      }
    end
  end
end
