class SearchResultsController < ApplicationController
  before_action :set_search_result, only: %i[show edit update destroy]

  # GET /search_results
  def index
    @search_results ||= []
    @result_id = 1
    return if params[:query].nil?

    query = params[:query].squish.downcase.gsub(/[[:punct:]]|[[:space:]]/, "_")
    return if query.match?(/^_*$/)

    search_for_entries_starting_with query
    search_for_entries_including query
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

  def add_search_results(rooms, buildings, locations, people)
    add_buildings(buildings)
    add_rooms(rooms)
    add_locations(locations)
    add_people(people)
  end

  def search_for_entries_starting_with(query)
    buildings = Building.where("LOWER(name) LIKE ?", "#{query}%")
    rooms = Room.where("LOWER(name) LIKE ?", "#{query}%")
    locations = Location.where("LOWER(name) LIKE ?", "#{query}%")
    people = Person.where("LOWER(first_name) || ' ' || LOWER(last_name) LIKE ?
                          OR LOWER(last_name) LIKE ?",
                          "#{query}%", "#{query}%")
    add_search_results(rooms, buildings, locations, people)
  end

  def search_for_entries_including(query)
    buildings = Building.where("LOWER(name) LIKE ? AND NOT LOWER(name) LIKE ?", "%#{query}%", "#{query}%")
    rooms = Room.where("LOWER(name) LIKE ? AND NOT LOWER(name) LIKE ?", "%#{query}%", "#{query}%")
    locations = Location.where("LOWER(name) LIKE ? AND NOT LOWER(name) LIKE ?", "%#{query}%", "#{query}%")
    people = Person.where("LOWER(first_name) || ' ' || LOWER(last_name) LIKE ?
                          AND NOT LOWER(first_name) || ' ' || LOWER(last_name) LIKE ?
                          AND NOT LOWER(last_name) LIKE ?",
                          "%#{query}%", "#{query}%", "#{query}%")
    add_search_results(rooms, buildings, locations, people)
  end

  def add_rooms(rooms)
    rooms.each do |room|
      @search_results.append(SearchResult.new(
                               id: @result_id,
                               title: room.name,
                               link: room_path(room),
                               description: "#{room.room_type} on floor #{room.floor} of #{room.building.name}",
                               type: "room"
                             ))
      @result_id += 1
    end
  end

  def add_buildings(buildings)
    buildings.each do |building|
      @search_results.append(SearchResult.new(
                               id: @result_id,
                               title: building.name,
                               link: building_path(building),
                               description: "Building",
                               type: "building"
                             ))
      @result_id += 1
    end
  end

  def add_locations(locations)
    locations.each do |location|
      @search_results.append(SearchResult.new(
                               id: @result_id,
                               title: location.name,
                               link: location_path(location),
                               description: "Location",
                               type: "location"
                             ))
      @result_id += 1
    end
  end

  def add_people(people)
    people.each do |person|
      @search_results.append(SearchResult.new(
                               id: @result_id,
                               title: person.name,
                               link: person_path(person),
                               description: "Person, E-Mail: #{person.email}",
                               type: "person"
                             ))
      @result_id += 1
    end
  end
end
