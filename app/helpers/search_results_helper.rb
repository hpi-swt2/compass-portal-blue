module SearchResultsHelper
  def starting_with_buildings(query)
    Building.where("LOWER(name) LIKE ? OR LOWER(name_de) LIKE ?",
                   "#{query}%", query.to_s)
  end

  def starting_with_rooms(query)
    Room.where("LOWER(name) || LOWER(room_type) LIKE ? OR LOWER(name_de) LIKE ?", "#{query}%", "#{query}%")
  end

  def starting_with_locations(query)
    Location.where("LOWER(name) LIKE ? OR LOWER(details) LIKE ? OR LOWER(name_de) LIKE ? OR LOWER(details_de) LIKE ?",
                   "#{query}%", "#{query}%", "#{query}%", "#{query}%")
  end

  def starting_with_people(query)
    Person.where("LOWER(first_name) || ' ' || LOWER(last_name) LIKE ?OR LOWER(last_name) LIKE ?",
                 "#{query}%", "#{query}%")
  end

  def including_buildings(query)
    Building.where("LOWER(name) LIKE ? AND NOT LOWER(name) LIKE ? OR LOWER(name_de) LIKE ? AND NOT
                  LOWER(name_de) LIKE ? ", "%#{query}%", "#{query}%", "%#{query}%", "#{query}%")
  end

  def including_rooms(query)
    Room.where("LOWER(name) || LOWER(room_type) LIKE ? AND NOT LOWER(name) ||
          LOWER(room_type) LIKE ? OR LOWER(name_de) LIKE ? AND NOT LOWER(name_de) LIKE ? ",
               "%#{query}%", "#{query}%", "%#{query}%", "#{query}%")
  end

  def including_locations(query)
    Location.where("LOWER(name) LIKE ? AND NOT LOWER(name) LIKE ? OR LOWER(name_de) LIKE ? AND NOT
          LOWER(name_de) LIKE ? OR LOWER(details_de) LIKE ? AND NOT LOWER(details_de) LIKE ? OR LOWER(details) LIKE ?
          AND NOT LOWER(details) LIKE ?", "%#{query}%", "#{query}%", "%#{query}%", "#{query}%", "%#{query}%",
                   "#{query}%", "%#{query}%", "#{query}%")
  end

  def including_people(query)
    Person.where("LOWER(first_name) || ' ' || LOWER(last_name) LIKE ? AND NOT LOWER(first_name) || ' ' ||
            LOWER(last_name) LIKE ? AND NOT LOWER(last_name) LIKE ?", "%#{query}%", "#{query}%", "#{query}%")
  end

  def search_events_by_name_or_description(query)
    events = Event.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
    add_results(events, "event")
  end
end
