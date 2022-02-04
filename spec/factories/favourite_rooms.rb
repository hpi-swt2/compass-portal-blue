FactoryBot.define do
  factory :favourite_room do
    association :room
    association :user
  end
end
