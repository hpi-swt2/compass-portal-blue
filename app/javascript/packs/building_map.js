setupMap();

function setupMap() {
    const map = L.map("map")
    L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 19,
    }).addTo(map);
    
    // these operations are executed in parallel
    getView().then(view => {
        map.setView(view["latlng"], view["zoom"]);
    });

    getBuildings().then(buildingPolygons => {
        addPolygons(buildingPolygons, map);
    });

    getBuildingMarkers().then(buildingMarkers => {
        addMarkers(buildingMarkers, map);
    });
    // polylines.forEach((polyline) => {
    //     L.polyline(polyline["latlngs"], polyline["options"]).addTo(map);
    // });
}

function addPolygons(polygons, map) {
    polygons.forEach((polygon) => {
        L.polygon(polygon["latlngs"], polygon["options"]).addTo(map);
    });
}

function addMarkers(markers, map) {
    markers.forEach((marker) => {
        marker["divIcon"]["iconSize"] = [];
        marker["divIcon"]["iconAnchor"] = [0, 0];
        marker["divIcon"]["popupAnchor"] = [0, 0];
        const icon = L.divIcon(marker["divIcon"]);
        L.marker(marker["latlng"], { icon: icon }).addTo(map);
    });
}

async function getRoute() {
    return $.ajax({
        type: "GET",
        url: "building_map_route", //sumbits it to the given url of the form
        // data: `?start=${start}&dest=${dest}`,
        dataType: "json"
    });
}

async function getBuildings() {
    return $.ajax({
        type: "GET",
        url: "building_map_buildings", //sumbits it to the given url of the form
        // data: `?start=${start}&dest=${dest}`,
        dataType: "json"
    });
}

async function getBuildingMarkers() {
    return $.ajax({
        type: "GET",
        url: "building_map_markers",
        dataType: "json"
    });
}

async function getView() {
    return $.ajax({
        type: "GET",
        url: "building_map_view", //sumbits it to the given url of the form
        // data: `?start=${start}&dest=${dest}`,
        dataType: "json"
    });
}

