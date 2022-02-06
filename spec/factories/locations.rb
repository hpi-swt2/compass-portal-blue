FactoryBot.define do
  factory :location do
    name { "cafe" }
    details { "cafe-details" }
    location_latitude { 1.5 }
    location_longitude { 3.5 }
  end
end
