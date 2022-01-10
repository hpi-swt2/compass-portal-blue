import { displayRoute, setupMap, map, getMap } from './leafletMap.js';

let currentLocation;
const YOUR_LOCATION_MAGIC_STRING = "Your location" // TODO: Change this!!!

setupMap();

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
    });

function validate_place_input(inputId, optionsId) {
    const input = document.getElementById(inputId);
    const options = document.getElementById(optionsId).options;
    return Array.from(options).some((o) => o.value === input.value);
}

function request_location() {
    if (start_input_field.value !== YOUR_LOCATION_MAGIC_STRING) return;
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

// TODO: Indoor Labels:

// function addIndoorLabel(feature, layer) {
//     layer.bindTooltip(feature.properties.name, {
//         permanent: true,
//         direction: "center",
//         className: "indoor-label",
//     });
// }

// function loadGeoJsonFile(filename) {
//     fetch(filename)
//         .then((response) => response.json())
//         .then((geojsonFeatureCollection) => {
//             // Manually add indoor labels to map
//             const rooms = L.geoJSON(geojsonFeatureCollection, {
//                 onEachFeature: addIndoorLabel,
//             }).addTo(map);
//             rooms.eachLayer((layer) => {
//                 layer.getTooltip().setLatLng(layer.getBounds().getCenter());
//             });
//             recalculateTooltipVisibility();
//         });
// }

// loadGeoJsonFile("assets/lecture-hall-building.geojson");
// function recalculateTooltipVisibility() {
//     const zoomLevel = map.getZoom();
//     map.eachLayer((layer) => {
//         if (layer.getTooltip()) {
//             if (zoomLevel == 19 /* nearest zoom */) {
//                 layer.openTooltip(layer.getBounds().getCenter());
//             } else {
//                 layer.closeTooltip();
//             }
//         }
//     });
// }
// map.on("zoomend", recalculateTooltipVisibility);
