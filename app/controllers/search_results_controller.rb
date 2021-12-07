class SearchResultsController < ApplicationController
  before_action :set_search_result, only: %i[show edit update destroy]

  # GET /search_results
  def index
    @search_results ||= []
    result_id = 0
    Building.all.each do |
    building|
    	@search_results.append(SearchResult.new(
    	
    	id: result_id,
    	
    	title: building.name,
    	
    	link: building_path(building)
    	))
    result_id += 1
    end
    
    Room.all.each do |
    room|
    	@search_results.append(SearchResult.new(
    	
    	id: result_id,
    	
    	title: room.name,
    	
    	link: room_path(room)
    	))
    result_id += 1
    end
    
   
    	
    @search_results = @search_results.uniq(&:id)
  end

  def create
    @search_result = SearchResult.new(search_result_params)
  end

  # There is no need to display one singular SearchResult.
  def show; end

  # SearchResults are currently not stored a database so no need to edit one.
  def edit; end

  # SearchResults are currently not stored a database so no need to update one.
  def update; end

  # All SearchResult objects will be destroyed after they are no longer used.
  def destroy; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_search_result
    @search_result = SearchResult.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def search_result_params
    params.require(:title, :link).permit(:description, :resource)
  end
end