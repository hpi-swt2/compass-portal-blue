FactoryBot.define do
  factory :person do
    first_name { 'Herbert' }
    last_name { 'Herbertson' }
    phone_number { '+49 90909090' }
    email { "herbert.herbertson@hpi.de" }
  end
end
