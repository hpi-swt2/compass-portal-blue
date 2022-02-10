require 'ice_cube'

FactoryBot.define do
  factory :event do
    association :room
    name { "BA Mathematik III Übung" }
    description { "Teaching mathematics" }
    start_time { "2021-10-25 13:15:00" }
    end_time { "2021-10-25 14:45:00" }

    trait :in_one_hour do
      name { "Future Event" }
      start_time { 1.hour.from_now }
      end_time { 2.hours.from_now }
      recurring { IceCube::Rule.daily.to_yaml }
    end

    trait :right_now do
      name { "Current Event" }
      start_time { 30.minutes.ago }
      end_time { 30.minutes.from_now }
      recurring { IceCube::Rule.daily.to_yaml }
    end

    recurring { IceCube::Rule.weekly.day(:monday).to_yaml }
  end
end
