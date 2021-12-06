FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    username { 'user' }
    first_name { 'Herbert' }
    last_name { 'Herbertson' }
    phone_number { '+49 90909090' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
