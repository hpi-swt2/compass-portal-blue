json.extract! room, :id, :name, :floor, :room_type, :contact_person, :created_at, :updated_at
json.url room_url(room, format: :json)
