require "rails_helper"

describe "Building Map api", type: :request do
  it "calculates the correct route" do
    Building.create!(
      name: 'Haus A',
      location_latitude: "52.3934534",
      location_longitude: "13.1312424"
    )
    Building.create!(
      name: 'Haus L',
      location_latitude: "52.39262",
      location_longitude: "13.12488"
    )
    get building_map_route_path(start: 'Haus A', dest: 'Haus L', locale: I18n.locale), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end

  it "calculates a route inside the same building" do
    a = Building.create!(
      name: 'Haus A',
      location_latitude: "52.3934534",
      location_longitude: "13.1312424"
    )
    Room.create!(
      name: 'A-E.7',
      location_latitude: "52.39331",
      location_longitude: "13.13146",
      floor: 0,
      room_type: "seminar-room",
      building: a
    )
    Room.create!(
      name: 'A-2.9',
      location_latitude: "52.39336",
      location_longitude: "13.13166",
      floor: 2,
      room_type: "seminar-room",
      building: a
    )
    get building_map_route_path(start: "A-E.7", dest: "A-2.9"), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    puts json
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end
end
