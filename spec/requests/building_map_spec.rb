require "rails_helper"

describe "Building Map api", type: :request do
  before do
    a = Building.create!(
      name: 'Haus A',
      location_latitude: "52.3934534",
      location_longitude: "13.1312424"
    )
    main = Building.create!(
      name: 'Hauptgebäude',
      location_latitude: "52.39402",
      location_longitude: "13.13342"
    )
    Location.create!(
      name: 'Mister Net',
      location_latitude: "52.39381",
      location_longitude: "13.13162"
    )
    Building.create!(
      name: 'Haus L',
      location_latitude: "52.39262",
      location_longitude: "13.12488"
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
    Room.create!(
      name: 'H-3.31',
      location_latitude: "52.39408",
      location_longitude: "13.13333",
      floor: 3,
      room_type: "seminar-room",
      building: main
    )
  end

  it "calculates the correct route" do
    get building_map_route_path(start: 'Haus A', dest: 'Haus L'), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end

  it "calculates a route inside the same building" do
    get building_map_route_path(start: "A-E.7", dest: "A-2.9"), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end

  it "calculates a route from a room in one building to a room in another building" do
    get building_map_route_path(start: "A-E.7", dest: "H-3.31"), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end

  it "calculates a route from a room in one building to a location outdoor" do
    get building_map_route_path(start: "A-E.7", dest: "Hauptgebäude"), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end

  it "calculates a route from an outdoor location to a room in a building" do
    get building_map_route_path(start: "Mister Net", dest: "H-3.31"), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end

  it "can find a door near a given location" do
    # We can't simulate a pin on the map so we simulate this with a location in order to find a closest door node
    Location.create!(
      name: 'Simulated Marker',
      location_latitude: "52.39334",
      location_longitude: "13.13246"
    )
    get building_map_route_path(start: "Simulated Marker", dest: "A-E.7"), as: :json
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json; charset=utf-8")
    json = JSON.parse response.body
    expect(json).to have_key('polylines')
    expect(json).to have_key('marker')
    expect(json['polylines']).not_to be_empty
    expect(json['marker']).not_to be_empty
  end
end
