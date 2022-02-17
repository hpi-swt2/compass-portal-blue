FactoryBot.define do
  factory :location do
    name { "cafe" }
    name_de { "cafe de" }
    details { "cafe-details" }
    details_de { "cafe-details de" }
    location_latitude { 1.5 }
    location_longitude { 3.5 }
  end
end
