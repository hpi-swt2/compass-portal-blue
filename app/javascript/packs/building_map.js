import GpsManager from "./gps_manager.js";
import { addAnyMarker, displayRoute, pins, setupMap } from './leafletMap.js';
import { lazyInit, ratelimit } from "./utils.js";

// FIXME: this should probably be in application.js or something similarly
// global, but it didn't work when we put it there
// The `lazyinit` is needed, because the `querySelector` seems to, somewhat
// randomly, block the execution of the script in our tests. This is a
// workaround, until a real solution is found.
const csrfToken = lazyInit(() => document.querySelector('meta[name="csrf-token"]').getAttribute("content"));

const gpsManager = new GpsManager();

const YOUR_LOCATION_MAGIC_STRING = "Your location" // This will be changed when the page supports multiple languages
const PIN_1_MAGIC_STRING = "Pin 1"
const PIN_2_MAGIC_STRING = "Pin 2"

setupMap();
const trackingSwitch = document.getElementById("trackingSwitch");
trackingSwitch.addEventListener("click", trackingHandler);

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
    .addEventListener("submit", event => {
        event.preventDefault();
        let coordinates = [startInputField.value, destInputField.value];
        (async () => {
            for (let i = 0; i < coordinates.length; i++) {
                switch (coordinates[i]) {
                    case YOUR_LOCATION_MAGIC_STRING:
                        coordinates[i] = await gpsManager.currentLocationString();
                        break;
                    case PIN_1_MAGIC_STRING:
                        coordinates[i] = pinCoordinatesString(pins[0]);
                        break;
                    case PIN_2_MAGIC_STRING:
                        coordinates[i] = pinCoordinatesString(pins[1]);
                        break;
                }
            }
            displayRoute(coordinates[0], coordinates[1]);
        })();
    });

function pinCoordinatesString(pin) {
    return String(pin.getLatLng().lat.toFixed(7)) + "," + String(pin.getLatLng().lng.toFixed(7))
}

function validatePlaceInput(inputId, optionsId) {
    const input = $(`#${inputId}`)[0];
    const options = $(`#${optionsId}`)[0].options;
    return Array.from(options).some((o) => o.value === input.value);
}

function resolveMagicPinStrings(inputField) {
    if (inputField.value === PIN_1_MAGIC_STRING) {
        checkPinExistence(0, inputField);
    } else if (inputField.value === PIN_2_MAGIC_STRING) {
        checkPinExistence(1, inputField);
    }
}

function resolveMagicStrings(inputField) {
    switch (inputField.value) {
        case YOUR_LOCATION_MAGIC_STRING:
            // This populates the cached location value with a current reading
            // TODO: We should clarify the behavior of the two features with POs
            //   - Should a navigation from "Your location" always stick to the
            //   location that was current when the start was selected? If so,
            //   we should probably keep that information around _in the form_
            //   / in the input and not in global javascript objects or ...
            //   - Should the most recent location always be requested when the
            //   form is actually submitted?
            gpsManager.currentLocation()
                .then(() => inputField.setCustomValidity(""))
                .catch(({ customMessage }) => inputField.setCustomValidity(customMessage));
            break;
        case PIN_1_MAGIC_STRING:
        case PIN_2_MAGIC_STRING:
            resolveMagicPinStrings(inputField);
            break;
        default:
            inputField.setCustomValidity("");
    }
}

function checkPinExistence(pinNumber, inputField) {
    if (!pins[pinNumber] || pins[pinNumber] === null) {
        inputField.setCustomValidity(
            "You have to click on the map to set a pin to use this feature."
        );
    } else {
        inputField.setCustomValidity("");
    }
}

const syncUserPositionWithServerImpl = async (location) => {
    const body = new URLSearchParams({ location });
    const response = await fetch(
        "/users/geo_location",
        {
            method: "PUT",
            body,
            headers: {
                "X-CSRF-TOKEN": csrfToken(),
            },
        }
    );
    console.assert(response.status === 204); // HTTP "No content"
};
const syncUserPositionWithServer = ratelimit(syncUserPositionWithServerImpl, 10000);

const positionIcon = L.icon({ iconUrl: "assets/current-location.svg", iconSize: [30, 30], iconAnchor: [15, 15] });
const positionMarker = L.marker([0, 0], { icon: positionIcon });
positionMarker.bindPopup("Your position");

function trackingHandler() {
    if (trackingSwitch.checked) {
        addAnyMarker(positionMarker);
        gpsManager.registerCallback(location => {
            positionMarker.setLatLng([location.coords.latitude, location.coords.longitude]);
            syncUserPositionWithServer(GpsManager.formatLocation(locationString));
        });
    } else {
        gpsManager.clearAllCallbacks();
        gpsManager.forgetLastKnownLocation();
        positionMarker.remove();
    }
}
