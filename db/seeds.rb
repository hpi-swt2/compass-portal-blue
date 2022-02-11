require 'ice_cube'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
hsg = Building.create!(name: "Hörsaalgebäude", location_latitude: 0.5321, location_longitude: 0.8763)
hptg = Building.create!(name: "Hauptgebäude", location_latitude: 0.1674, location_longitude: 0.2345)
hs1 = Room.create!(name: "Hörsaal1", floor: 0, room_type: "lecture-hall", building: hsg, location_latitude: 0.5322,
                   location_longitude: 0.8764)
hs2 = Room.create!(name: "Hörsaal2", floor: 0, room_type: "lecture-hall", building: hsg, location_latitude: 0.5522,
                   location_longitude: 0.9764)
h257 = Room.create!(name: "H.257", floor: 2, room_type: "seminar-room", building: hptg, location_latitude: 0.5122,
                    location_longitude: 0.8754)
Event.create!(name: "Mathe 1", description: "Mathe 1 Vorlesung bei Meinel", start_time: "2022-01-23 10:58:13",
              end_time: "2022-01-23 11:58:13", recurring: "", room: hs1)
Event.create!(name: "Betriebssysteme", description: "BS", start_time: "2022-01-03 08:00:13",
              end_time: "2022-01-03 9:58:13", recurring: IceCube::Rule.weekly.day(:monday).to_yaml, room: hs2)
Event.create!(name: "CG", description: "CG", start_time: "2022-01-21 10:58:13", end_time: "2022-01-21 11:58:13",
              recurring: "", room: h257)
