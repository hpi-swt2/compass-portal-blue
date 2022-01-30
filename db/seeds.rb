# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
hsg = Building.create!(name: "Hörsaalgebäude", location_latitude: 0.5321, location_longitude: 0.8763)
hptg = Building.create!(name: "Hauptgebäude", location_latitude: 0.1674, location_longitude: 0.2345)
Room.create!(name: "Hörsaal1", floor: 0, room_type: "Hörsaal", building: hsg)
Room.create!(name: "Hörsaal2", floor: 0, room_type: "Hörsaal", building: hsg)
Room.create!(name: "H.257", floor: 2, room_type: "Seminarraum", building: hptg)
