FactoryBot.define do
  factory :room do
    association :building
    association :user
    name { "C.2.4" }
    floor { "2" }
    room_type { "Bachelorproject office" }
  end
end
