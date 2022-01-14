FactoryBot.define do
  factory :building do
    name { "A" }
    location_latitude { 1.5 }
    location_longitude { 3.5 }
    association :user
  end
end
