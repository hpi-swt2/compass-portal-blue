FactoryBot.define do
  factory :event do
    name { "MyString" }
    description { "MyText" }
    d_start { "2022-01-12 10:58:13" }
    d_end { "2022-01-12 10:58:13" }
    recurring { "MyText" }
  end
end
