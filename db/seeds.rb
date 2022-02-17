require 'ice_cube'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

def avg(coordinates)
  x = coordinates.reduce(0) { |acc, current| acc + current[0] } / coordinates.length
  y = coordinates.reduce(0) { |acc, current| acc + current[1] } / coordinates.length
  [x, y]
end

buildings_file = File.read("app/assets/geojsons/buildings.geojson")
buildings_json = JSON.parse(buildings_file)

buildings_json["features"].each do |building|
  next if !(building["properties"]["name"]) || !(building["properties"]["letter"])

  long, lat = avg(building["geometry"]["coordinates"][0])
  building_obj = Building.create!(name: building["properties"]["name"], location_latitude: lat,
                                  location_longitude: long)

  Dir.foreach('app/assets/geojsons') do |filename|
    next if (filename == '.') || (filename == '..') || filename.exclude?((building['properties']['letter']).to_s)

    file = File.read("app/assets/geojsons/#{filename}")
    json = JSON.parse(file)
    json["features"].each do |feature|
      is_feature_in_building = building["properties"]["letter"] == feature["properties"]["building"]
      unless feature["properties"]["indoor"] == 'room' && feature["properties"]["name-en"] && is_feature_in_building
        next
      end

      long, lat = avg(feature["geometry"]["coordinates"][0])
      Room.create!(
        name: feature["properties"]["name-en"],
        floor: Integer(feature["properties"]["level_name"]),
        room_type: feature["properties"]["type"],
        building: building_obj,
        location_latitude: lat,
        location_longitude: long
      )
    end
  end
end

# Event.create!(name: "Mathe 1", description: "Mathe 1 Vorlesung bei Meinel", start_time: "2022-01-23 10:58:13",
#     end_time: "2022-01-23 11:58:13", recurring: "", room: hs1)
# Event.create!(name: "Betriebssysteme", description: "BS", start_time: "2022-01-03 08:00:13",
#     end_time: "2022-01-03 9:58:13", recurring: IceCube::Rule.weekly.day(:monday).to_yaml, room: hs2)
# Event.create!(name: "CG", description: "CG", start_time: "2022-01-21 10:58:13", end_time: "2022-01-21 11:58:13",
#     recurring: "", room: h257)
