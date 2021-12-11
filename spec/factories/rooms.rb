FactoryBot.define do
  factory :room do
    association :building
    people { create_list(:person, 2) }
    name { "C.2.4" }
    floor { 2 }
    room_type { "Bachelorproject office" }
  end
end
