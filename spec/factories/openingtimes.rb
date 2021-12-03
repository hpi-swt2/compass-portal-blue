FactoryBot.define do
  factory :openingtime do
    opens { Tod::TimeOfDay.new(8, 15) }
    closes { Tod::TimeOfDay.new(12, 30)}
    day { 1 }
    association :timeable, factory: :building

  end
end
