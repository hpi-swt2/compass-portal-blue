require 'ice_cube'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
hsg = Building.create!(name: "Hoersaalgebäude", location_latitude: 0.5321, location_longitude: 0.8763)
hptg = Building.create!(name: "Hauptgebäude", location_latitude: 0.1674, location_longitude: 0.2345)
haus_a = Building.create!(name: "Haus A", location_latitude: 0, location_longitude: 0)
Room.create!(name: "Hoersaal1", floor: 0, room_type: "Hoersaal", building: hsg)
Room.create!(name: "A1.1", floor: 1, room_type: "Seminarraum", building: haus_a)
hörsaal = Room.create!(name: "Hörsaal2", floor: 0, room_type: "Hörsaal", building: hsg)
seminar_room = Room.create!(name: "H.257", floor: 2, room_type: "Seminarraum", building: hptg)
Event.create!(name: "Mathe 1", description: "Mathe 1 Vorlesung bei Meinel", d_start: "2022-01-23 10:58:13", d_end: "2022-01-23 11:58:13", recurring: "",  room: seminar_room)
Event.create!(name: "Betriebssysteme", description: "BS", d_start: "2022-01-23 08:00:13", d_end: "2022-01-23 9:58:13", recurring: IceCube::Rule.weekly.day(:monday).to_yaml,  room: seminar_room)
Event.create!(name: "CG", description: "CG", d_start: "2022-01-21 10:58:13", d_end: "2022-01-21 11:58:13", recurring: "",  room: hörsaal)
