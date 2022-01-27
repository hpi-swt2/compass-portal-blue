require 'ice_cube'

FactoryBot.define do
  factory :event do
    association :room
    name { "BA Mathematik III Übung" }
    description { "Teaching mathematics" }

    d_start { "2021-10-25 13:15:00" }
    d_end { "2021-10-25 14:45:00" }

    trait :in_one_hour do
      name { "Future Event" }
      d_start { 1.hour.from_now }
      d_end { 2.hours.from_now }
      recurring { IceCube::Rule.daily.to_yaml }
    end

    trait :right_now do
      name { "Current Event" }
      d_start { 30.minutes.ago }
      d_end { 30.minutes.from_now }
      recurring { IceCube::Rule.daily.to_yaml }
    end

    recurring { IceCube::Rule.weekly.day(:monday).to_yaml }

  end
end
