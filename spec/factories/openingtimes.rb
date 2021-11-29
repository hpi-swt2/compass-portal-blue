FactoryBot.define do
  factory :openingtime do
    opens { "2021-11-29 07:41:48" }
    closes { "2021-11-29 07:41:48" }
    day { 1 }
    timeable_type { "building" }
    timeable_id { 1 }

  end
end
