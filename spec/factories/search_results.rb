FactoryBot.define do
  factory :search_result do
    sequence(:id) { |n| n.to_s }
    sequence(:title) { |n| "Search Result #{n}" }
    link { Rails.application.routes.url_helpers.search_results_path }
  end
end
