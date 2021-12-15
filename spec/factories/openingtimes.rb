FactoryBot.define do
  factory :openingtime do
    opens { Tod::TimeOfDay.new 8 }
    closes { Tod::TimeOfDay.new 12 }
    day { 1 }
    association :timeable, factory: [:building, :location]

  end
end
