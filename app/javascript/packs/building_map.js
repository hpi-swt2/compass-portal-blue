let currentLocation;
const YOUR_LOCATION_MAGIC_STRING = "Your location" // TODO: Change this!!!

const start_input_field = document.getElementById("start_input");
start_input_field.addEventListener("change", () => {
    request_location();
    if (validate_place_input("start_input", "startOptions")) {
        start_input_field.setCustomValidity("");
    } else {
        start_input_field.setCustomValidity(
            "Please select a valid starting place."
        );
    }
});
start_input_field.dispatchEvent(new Event("change"));

const dest_input_field = document.getElementById("dest_input");
dest_input_field.addEventListener("change", () => {
    if (validate_place_input("dest_input", "destOptions")) {
        dest_input_field.setCustomValidity("");
    } else {
        dest_input_field.setCustomValidity(
            "Please select a valid destination place."
        );
    }
});
dest_input_field.dispatchEvent(new Event("change"));

document
    .getElementById("navigation_form")
    .addEventListener("submit", (event) => {
        event.preventDefault();
        if (start_input_field.value === YOUR_LOCATION_MAGIC_STRING) {
            start_input_field.value = currentLocation;
        }
        const start = start_input_field.value;
        const dest = dest_input_field.value;
        displayRoute(start, dest);
        console.log("Routing calculate");
    });

function validate_place_input(inputId, optionsId) {
    const input = document.getElementById(inputId);
    const options = document.getElementById(optionsId).options;
    return Array.from(options).some((o) => o.value === input.value);
}

function request_location() {
    console.log("T1");
    if (start_input_field.value !== YOUR_LOCATION_MAGIC_STRING) return;
    console.log("Test");
    navigator.geolocation.getCurrentPosition(
        (pos) => {
            currentLocation =
                String(pos.coords.latitude) +
                "," +
                String(pos.coords.longitude);
            start_input_field.setCustomValidity("");
        },
        (error) => {
            console.warn(`ERROR(${error.code}): ${error.message}`);
            if (error.code === GeolocationPositionError.PERMISSION_DENIED) {
                start_input_field.setCustomValidity(
                    "You have to grant your browser the permission to access your location if you want to use this feature."
                );
            } else {
                start_input_field.setCustomValidity(
                    "Your browser could not determine your position. Please choose a different starting place."
                );
            }
        }
    );
}

// Map features
let map;
setupMap();

async function setupMap() {
    map = L.map("map");
    L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution:
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 19,
    }).addTo(map);

    // these operations are executed in parallel
    getView().then((view) => {
        map.setView(view["latlng"], view["zoom"]);
    });

    getBuildings().then((buildingPolygons) => {
        addPolygons(buildingPolygons);
    });

    getBuildingMarkers().then((buildingMarkers) => {
        addMarkers(buildingMarkers);
    });
}

function addPolygons(polygons) {
    polygons.forEach((polygon) => {
        L.polygon(polygon["latlngs"], polygon["options"]).addTo(map);
    });
}

function addMarkers(markers) {
    markers.forEach((marker) => {
        marker["divIcon"]["iconSize"] = [];
        marker["divIcon"]["iconAnchor"] = [0, 0];
        marker["divIcon"]["popupAnchor"] = [0, 0];
        const icon = L.divIcon(marker["divIcon"]);
        L.marker(marker["latlng"], { icon: icon }).addTo(map);
    });
}

function addPolylines(polylines) {
    polylines.forEach((polyline) => {
        L.polyline(polyline["latlngs"], polyline["options"]).addTo(map);
    });
}

async function displayRoute(start, dest) {
    const route = await $.ajax({
        type: "GET",
        url: "building_map_route",
        data: `start=${start}&dest=${dest}`,
        dataType: "json",
    });
    console.log(route);
    addPolylines([route["polyline"]], map);
    addMarkers(route["markers"], map);
}

async function getBuildings() {
    return $.ajax({
        type: "GET",
        url: "building_map_buildings",
        dataType: "json",
    });
}

async function getBuildingMarkers() {
    return $.ajax({
        type: "GET",
        url: "building_map_markers",
        dataType: "json",
    });
}

async function getView() {
    return $.ajax({
        type: "GET",
        url: "building_map_view",
        dataType: "json",
    });
}
