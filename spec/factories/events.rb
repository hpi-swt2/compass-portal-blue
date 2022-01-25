require 'ice_cube'

FactoryBot.define do
  factory :event do
    association :room
    name { "BA Mathematik III Übung" }
    description { "Teaching mathematics" }
    d_start { "2021-10-25 13:15:00" }
    d_end { "2021-10-25 14:45:00" }
    recurring { IceCube::Rule.weekly.day(:monday).to_yaml }
  end
end
