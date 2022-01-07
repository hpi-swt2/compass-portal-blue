json.extract! event, :id, :name, :d_start, :recurring, :created_at, :updated_at
json.url event_url(event, format: :json)
