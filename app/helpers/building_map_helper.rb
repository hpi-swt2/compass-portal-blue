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
    self.buildings.merge(self.locations)
  end

  def self.buildings
    buildings = Building.all.to_h do |building|
      [ building.name, "#{building.location_latitude},#{building.location_longitude}" ]
    end
  end

  def self.find_room(name)
    Room.find_by(name: name)
  end

  def self.locations
    locations = Location.all.to_h do |location|
      [ location.name, "#{location.location_latitude},#{location.location_longitude}" ]
    end
  end

  def self.rooms
    rooms = Room.all.to_h do |room|
      [ room.name, "" ] # "#{room.location_latitude},#{room.location_longitude}"
    end
  end

  def self.building?(building)
    not self.buildings[building].nil?
  end

  def self.map_building_name_to_graph(name)
    case name
    when 'Haus A', 'Haus B', 'Haus C'
      return 'HausABC'
    end
    name
  end

  def self.location?(location)
    not self.locations[location].nil?
  end

  def self.room?(room)
    not self.rooms[room].nil? 
  end
end
