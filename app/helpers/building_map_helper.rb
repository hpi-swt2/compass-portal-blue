module BuildingMapHelper
  def self.leaflet_center
    {
      latlng: %w[52.39339 13.13208],
      zoom: 17
    }
  end

  def self.destinations
    buildings.merge(locations).merge(rooms)
  end

  def self.buildings
    Building.all.to_h do |building|
      [ building.name, "#{building.location_latitude},#{building.location_longitude}" ]
    end
  end

  def self.find_room(name)
    Room.find_by(name: name)
  end

  def self.locations
    Location.all.to_h do |location|
      [ location.name, "#{location.location_latitude},#{location.location_longitude}" ]
    end
  end

  def self.rooms
    Room.all.to_h do |room|
      [ room.name, "" ] # "#{room.location_latitude},#{room.location_longitude}"
    end
  end

  def self.building?(building)
    !buildings[building].nil?
  end

  def self.map_building_name_to_graph(name)
    case name
    when 'Haus A', 'Haus B', 'Haus C'
      return 'ABC'
    end
    name
  end

  def self.location?(location)
    !locations[location].nil?
  end

  def self.room?(room)
    !rooms[room].nil?
  end
end
