import { displayRoute, setupMap } from './leafletMap.js';

let currentLocation;
const YOUR_LOCATION_MAGIC_STRING = "Your location" // This will be changed when the page supports multiple languages
const PIN_1_MAGIC_STRING = "Pin 1"
const PIN_2_MAGIC_STRING = "Pin 2"

setupMap();

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
        const start = start_input_field.value;
        const dest = dest_input_field.value;
        displayRoute(start, dest);
    });

function pinCoordinatesString(pin){
    return String(pin.getLatLng().lat.toFixed(7)) + "," + String(pin.getLatLng().lng.toFixed(7))
}

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
