class SearchResultsController < ApplicationController
  include SearchResultsHelper
  before_action :set_search_result, only: %i[show edit update destroy]

  # GET /search_results
  def index
    @search_results ||= []
    @result_id = 1
    return if params[:query].nil?

    query = params[:query].squish.downcase.gsub(/[[:punct:]]|[[:space:]]/, "_")
    return if query.match?(/^_*$/)

    search_for query
    sort_search_results
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
    add_results(buildings, "building")
    add_results(rooms, "room")
    add_results(locations, "location")
    add_results(people, "person")
  end

  def search_for_entries_starting_with(query)
    add_search_results(starting_with_rooms(query), starting_with_buildings(query), starting_with_locations(query),
                       starting_with_people(query))
  end

  def search_for_entries_including(query)
    add_search_results(including_rooms(query), including_buildings(query), including_locations(query),
                       including_people(query))
  end

  def add_results(objects, type)
    objects.each do |object|
      result = SearchResult.new(
        id: @result_id, title: object.name, link: polymorphic_path(object), type: type,
        description: object.respond_to?(:search_description) ? object.search_description : "",
        location_latitude: object.respond_to?(:location_longitude) ? object.location_latitude : nil,
        location_longitude: object.respond_to?(:location_longitude) ? object.location_longitude : nil
      )
      @search_results.append(result)
      @result_id += 1
    end
  end

  def search_for(query)
    search_for_entries_starting_with(query)
    search_for_entries_including(query)
    search_events_by_name_or_description(query)
  end

  def search_by_name(query)
    # New Models that can be searched for by name can simply be added in this collection
    searchable_records = [Building]

    searchable_records.each do |record|
      type = record.name.downcase
      found_objects = record.where("LOWER(name) LIKE ?", "%#{query}%")
      add_results(found_objects, type)
    end
  end

  include Math
  # See https://en.wikipedia.org/wiki/Great-circle_distance
  def distance(location1, location2)
    earth_radius = 6_371_000
    earth_radius * calculate_central_angle(location1[:long], location2[:long], location1[:lat], location2[:lat])
  end

  def calculate_central_angle(phi1, phi2, lambda1, lambda2)
    acos((sin(phi1) * sin(phi2)) + (cos(phi1) * cos(phi2) * cos((lambda1 - lambda2).abs)))
  end

  def location_to_radians(location)
    { lat: location[0] * (PI / 180), long: location[0] * (PI / 180) }
  end

  def sort_search_results
    @sort_location = params[:sort_location].nil? ? "false" : params[:sort_location]
    @search_query = params[:query]
    @search_results = @search_results.sort_by(&:title)
    sort_by_location if @sort_location == "true"
  end

  def valid_user_location
    return nil if current_user.nil? || current_user.last_known_location_with_timestamp.nil?

    current_user.last_known_location_with_timestamp[0].split(',').map(&:to_f)
  end

  def sort_by_location
    current_position = valid_user_location
    return unless current_position

    @search_results = @search_results.sort_by do |r|
      if r.position_set?
        distance(location_to_radians(current_position),
                 location_to_radians([r.location_latitude, r.location_longitude]))
      else
        r.id * (10**6) # keep search results in order if no location is provided
      end
    end
  end
end
