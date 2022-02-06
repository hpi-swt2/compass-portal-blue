FactoryBot.define do
  factory :person do
    first_name { 'Herbert' }
    last_name { 'Herbertson' }
    phone_number { '+4990909090' }
    email { "herbert.herbertson@hpi.de" }
  end
end
