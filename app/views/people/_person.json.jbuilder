json.extract! person, :id, :phone_number, :first_name, :last_name, :email, :created_at, :updated_at
json.url person_url(person, format: :json)
