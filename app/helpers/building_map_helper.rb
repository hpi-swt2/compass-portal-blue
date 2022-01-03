module BuildingMapHelper
  def self.leaflet_center(start_coordinates)
    center = start_coordinates.nil? ? %w[52.39339 13.13208] : start_coordinates.split(",")

    {
      latlng: center,
      zoom: 17
    }
  end

  def self.leaflet_polygons
    Buildings.transform_leaflet_buildings(Buildings::UNIPOTSDAM_POLYONGS, Buildings::UNIPOTSDAM_STYLING) +
      Buildings.transform_leaflet_buildings(Buildings::HPI_POLYGONS, Buildings::HPI_STYLING)
  end

  def self.leaflet_polylines(route)
    route.present? ? [RoutingHelper.transform_route_to_polyline(route)] : []
  end

  def self.leaflet_markers(route, target)
    Buildings.transform_leaflet_letters(Buildings::HPI_LETTERS) +
      RoutingHelper.transform_route_to_time_marker(route) +
      RoutingHelper.transform_target_to_marker(target)
  end
end
