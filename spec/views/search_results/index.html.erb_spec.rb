require 'rails_helper'

RSpec.describe "search_results/index", type: :view do
  let(:number_of_results) { 5 }

  before do
    FactoryBot.rewind_sequences
    assign(:search_results, build_list(:search_result, number_of_results))
  end

  it "renders a list of search_results" do
    render
    1.upto(number_of_results) do |n|
      expect(rendered).to include("Search Result #{n}")
    end
  end
end
