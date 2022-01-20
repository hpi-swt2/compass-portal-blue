import { displayRoute, setupMap, pins } from './leafletMap.js';

let currentLocation;
const YOUR_LOCATION_MAGIC_STRING = "Your location" // This will be changed when the page supports multiple languages
const PIN_1_MAGIC_STRING = "Pin 1"
const PIN_2_MAGIC_STRING = "Pin 2"

setupMap();

const map = $("#map")[0];
map.addEventListener("click", () => {
    resolveMagicPinStrings(startInputField);
    resolveMagicPinStrings(destInputField);
})

const startInputField = $("#startInput")[0];
startInputField.addEventListener("change", () => {
    resolveMagicStrings(startInputField);
    if (!validatePlaceInput("startInput", "startOptions")) {
        startInputField.setCustomValidity(
            "Please select a valid starting place."
        );
    }
});
startInputField.dispatchEvent(new Event("change"));

const destInputField = $("#destInput")[0];
destInputField.addEventListener("change", () => {
    resolveMagicStrings(destInputField);
    if (!validatePlaceInput("destInput", "destOptions")) {
        destInputField.setCustomValidity(
            "Please select a valid destination place."
        );
    }
});
destInputField.dispatchEvent(new Event("change"));

$("#navigationForm")[0]
    .addEventListener("submit", (event) => {
        event.preventDefault();
        let coordinates = [startInputField.value, destInputField.value];
        coordinates.forEach((routePoint, i) => {
            switch(routePoint){
                case YOUR_LOCATION_MAGIC_STRING:
                    coordinates[i] = currentLocation;
                    break;
                case PIN_1_MAGIC_STRING:
                    coordinates[i] = pinCoordinatesString(pins[0]);
                    break;
                case PIN_2_MAGIC_STRING:
                    coordinates[i] = pinCoordinatesString(pins[1]);
                    break;
            }
        })
        displayRoute(coordinates[0], coordinates[1]);
    });

function pinCoordinatesString(pin){
    return String(pin.getLatLng().lat.toFixed(7)) + "," + String(pin.getLatLng().lng.toFixed(7))
}

function validatePlaceInput(inputId, optionsId) {
    const input = $(`#${inputId}`)[0];
    const options = $(`#${optionsId}`)[0].options;
    return Array.from(options).some((o) => o.value === input.value);
}

function resolveMagicPinStrings(inputField) {
    if(inputField.value === PIN_1_MAGIC_STRING){
        checkPinExistence(0, inputField);
    }else if(inputField.value === PIN_2_MAGIC_STRING) {
        checkPinExistence(1, inputField);
    }
}

function resolveMagicStrings(inputField) {
    switch (inputField.value) {
        case YOUR_LOCATION_MAGIC_STRING:
            requestLocation(inputField);
            break;
        case PIN_1_MAGIC_STRING:
        case PIN_2_MAGIC_STRING:
            resolveMagicPinStrings(inputField);
            break;
        default:
            inputField.setCustomValidity("");
    }
}

function checkPinExistence(pinNumber, inputField){
    if(!pins[pinNumber] || pins[pinNumber]===null){
        inputField.setCustomValidity(
            "You have to click on the map to set a pin to use this feature."
        );
    }else{
        inputField.setCustomValidity("");
    }
}

function requestLocation(inputField){
    navigator.geolocation.getCurrentPosition(
        (pos) => {
            currentLocation =
                String(pos.coords.latitude) +
                "," +
                String(pos.coords.longitude);
            inputField.setCustomValidity("");
        },
        (error) => {
            console.warn(`ERROR(${error.code}): ${error.message}`);
            if (error.code === GeolocationPositionError.PERMISSION_DENIED) {
                inputField.setCustomValidity(
                    "You have to grant your browser the permission to access your location if you want to use this feature."
                );
            } else {
                inputField.setCustomValidity(
                    "Your browser could not determine your position. Please choose a different place."
                );
            }
        }
    );
}
