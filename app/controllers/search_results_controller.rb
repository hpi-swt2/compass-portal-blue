class SearchResultsController < ApplicationController
  before_action :set_search_result, only: %i[show edit update destroy]

  # GET /search_results or /search_results.json
  def index
    @search_results ||= []

    10.times do |number|
      @search_results.append(
        SearchResult.new(
          id: number,
          title: format("Search Result %d", number),
          link: search_results_path
        )
      )
    end
    @search_results = @search_results.uniq(&:id)
  end

  def create
    @search_result = SearchResult.new(search_result_params)
  end

  def show
    # There is no need to display one singular SearchResult.
  end
  
  def edit
    # SearchResults are currently not stored a database so no need to edit one.
  end
  
  def update
    # SearchResults are currently not stored a database so no need to update one.
  end 
  
  def destroy
    # All SearchResult objects will be destroyed after they are no longer used.
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_search_result
    @search_result = SearchResult.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def search_result_params
    params.fetch(:search_result, {})
  end
end
