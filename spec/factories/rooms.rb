FactoryBot.define do
  factory :room do
    association :building
    name { "C.2.4" }
    floor { "2" }
    room_type { "Bachelorproject office" }
    contact_person { "Jonas Cremerius" }
  end
end
