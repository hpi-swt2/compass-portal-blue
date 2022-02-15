class SearchResultsController < ApplicationController
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

  def add_results(objects, type)
    objects.each do |object|
      result = SearchResult.new(
        id: @result_id, title: object.name, link: polymorphic_path(object), type: type,
        description: object.respond_to?(:search_description) ? object.search_description : "",
        location_latitude: object.instance_of?(Person) ? nil : object.location_latitude,
        location_longitude: object.instance_of?(Person) ? nil : object.location_longitude
      )
      @search_results.append(result)
      @result_id += 1
    end
  end

  def search_for(query)
    search_rooms_by_name_or_type query
    search_people_by_full_name query
    search_locations_by_name_or_details query
    search_by_name query
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

  def search_people_by_full_name(query)
    people = Person.where("LOWER(first_name) || ' ' || LOWER(last_name) LIKE ?", "%#{query}%")
    add_results(people, "person")
  end

  def search_rooms_by_name_or_type(query)
    rooms = Room.where("LOWER(name) LIKE ? OR LOWER(room_type) LIKE ?", "%#{query}%", "%#{query}%")
    add_results(rooms, "room")
  end

  def search_locations_by_name_or_details(query)
    locations = Location.where("LOWER(name) LIKE ? OR LOWER(details) LIKE ?", "%#{query}%", "%#{query}%")
    add_results(locations, "location")
  end

  def distance(loc1, loc2)
    a = sinus_calc(loc1[0], loc2[0]) + (cos_calc(loc1, loc2) * cos_calc(loc1, loc2) * sinus_calc(loc2[1] - loc1[1]))
    delta_calc(a)
  end

  def sinus_calc(loc1, loc2)
    rad_per_deg = Math::PI / 180
    Math.sin(((loc2 - loc1) * rad_per_deg) / 2)**2
  end

  def cos_calc(loc1, loc2)
    rad_per_deg = Math::PI / 180
    Math.cos(loc1.map { |i| i * rad_per_deg }.first) * Math.cos(loc2.map { |i| i * rad_per_deg }.first)
  end

  def delta_calc(calc_res)
    6_371_000 * 2 * Math.atan2(Math.sqrt(calc_res), Math.sqrt(1 - calc_res))
  end

  def sort_search_results
    @sort_location = params[:sort_location].nil? ? "false" : params[:sort_location]
    @search_query = params[:query]
    @search_results = @search_results.sort_by(&:title)
    sort_by_location if @sort_location == "true"
  end

  def sort_by_location
    return unless !current_user.nil? && !current_user.last_known_location_with_timestamp.nil?

    current_position = current_user.last_known_location_with_timestamp[0].split(',').map(&:to_f)
    @search_results =
      @search_results.sort_by { |r| distance(current_position, [r.location_latitude, r.location_longitude]) }
  end
end
