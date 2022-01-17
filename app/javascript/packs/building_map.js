import { displayRoute, setupMap, pins } from './leafletMap.js';

let currentLocation;
const YOUR_LOCATION_MAGIC_STRING = "Your location" // This will be changed when the page supports multiple languages
const PIN_1_MAGIC_STRING = "Pin 1"
const PIN_2_MAGIC_STRING = "Pin 2"

setupMap();

const startInputField = $("#startInput")[0];
startInputField.addEventListener("change", () => {
    requestLocation();
    if (validatePlaceInput("startInput", "startOptions")) {
        startInputField.setCustomValidity("");
    } else {
        startInputField.setCustomValidity(
            "Please select a valid starting place."
        );
    }
});
startInputField.dispatchEvent(new Event("change"));

const destInputField = $("#destInput")[0];
destInputField.addEventListener("change", () => {
    if (validatePlaceInput("destInput", "destOptions")) {
        destInputField.setCustomValidity("");
    } else {
        destInputField.setCustomValidity(
            "Please select a valid destination place."
        );
    }
});
destInputField.dispatchEvent(new Event("change"));

$("#navigationForm")[0]
    .addEventListener("submit", (event) => {
        event.preventDefault();
        for(let inputField of [startInputField, destInputField]){
            switch(inputField.value){
                case YOUR_LOCATION_MAGIC_STRING:
                    inputField.value = currentLocation;
                    break;
                case PIN_1_MAGIC_STRING:
                    inputField.value = pinCoordinatesString(pins[0]);
                    break;
                case PIN_2_MAGIC_STRING:
                    inputField.value = pinCoordinatesString(pins[1]);
                    break;
            }
        }
        const start = startInputField.value;
        const dest = destInputField.value;
        displayRoute(start, dest);
    });

function pinCoordinatesString(pin){
    return String(pin.getLatLng().lat.toFixed(7)) + "," + String(pin.getLatLng().lng.toFixed(7))
}

function validatePlaceInput(inputId, optionsId) {
    const input = $(`#${inputId}`)[0];
    const options = $(`#${optionsId}`)[0].options;
    return Array.from(options).some((o) => o.value === input.value);
}

function requestLocation() {
    if (startInputField.value !== YOUR_LOCATION_MAGIC_STRING) return;
    navigator.geolocation.getCurrentPosition(
        (pos) => {
            currentLocation =
                String(pos.coords.latitude) +
                "," +
                String(pos.coords.longitude);
            startInputField.setCustomValidity("");
        },
        (error) => {
            console.warn(`ERROR(${error.code}): ${error.message}`);
            if (error.code === GeolocationPositionError.PERMISSION_DENIED) {
                startInputField.setCustomValidity(
                    "You have to grant your browser the permission to access your location if you want to use this feature."
                );
            } else {
                startInputField.setCustomValidity(
                    "Your browser could not determine your position. Please choose a different starting place."
                );
            }
        }
    );
}
