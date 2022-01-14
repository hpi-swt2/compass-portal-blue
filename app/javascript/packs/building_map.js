import { displayRoute, addAnyMarker, ratelimit, setupMap } from './leafletMap.js';

// FIXME: this should probably be in application.js or something similarly
// global, but it didn't work when we put it there
const CSRF_TOKEN = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
const YOUR_LOCATION_MAGIC_STRING = "Your location" // This will be changed when the page supports multiple languages
let currentLocation;

setupMap();
document.getElementById("tracking_switch").addEventListener("click", trackingHandler);

const start_input_field = $("#start_input")[0];
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

const dest_input_field = $("#dest_input")[0];
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

$("#navigation_form")[0]
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
    const input = $(`#${inputId}`)[0];
    const options = $(`#${optionsId}`)[0].options;
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

const syncUserPositionWithServerImpl = async (location) => {
    const body = new URLSearchParams({ location });
    const response = await fetch(
        "/users/geo_location",
        {
            method: "PUT",
            body,
            headers: {
                "X-CSRF-TOKEN": CSRF_TOKEN,
            },
        }
    );
    console.assert(response.status === 204); // HTTP "No content"
};
const syncUserPositionWithServer = ratelimit(syncUserPositionWithServerImpl, 10000);

let watcher_id;
const positionIcon = L.icon({ iconUrl: "assets/current-location.svg", iconSize: [30, 30], iconAnchor: [15, 15] });
const positionMarker = L.marker([0, 0], { icon: positionIcon });
positionMarker.bindPopup("Your position");

function trackingHandler() {
    const tracking_switch = document.getElementById("tracking_switch");
    if (tracking_switch.checked) {
        addAnyMarker(positionMarker);
        watcher_id = navigator.geolocation.watchPosition(
            (pos) => {
                currentLocation = String(pos.coords.latitude) + "," + String(pos.coords.longitude);
                positionMarker.setLatLng([pos.coords.latitude, pos.coords.longitude]);
                syncUserPositionWithServer(currentLocation);
            },
            (error) => {
                alert("We cannot determine your location. Maybe you are not permitting your browser to determine your location.");
            }
        );
    } else {
        navigator.geolocation.clearWatch(watcher_id);
        positionMarker.remove();
    }
}
