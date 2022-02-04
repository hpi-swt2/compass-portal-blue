FactoryBot.define do
  factory :room do
    association :building
    people { create_list(:person, 2) }
    name { "C.2.4" }
    name_de { "C.2.4 de" }
    floor { 2 }
    location_latitude { 1.5 }
    location_longitude { 3.5 }
    room_type { "Bachelorproject office" }
  end
end
