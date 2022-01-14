json.extract! event, :id, :name, :description, :d_start, :d_end, :recurring, :created_at, :updated_at
json.url event_url(event, format: :json)
