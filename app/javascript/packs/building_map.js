import {
  PIN_1_MAGIC_STRING,
  PIN_2_MAGIC_STRING,
  YOUR_LOCATION_MAGIC_STRING,
} from "./constants";
import {
    addAnyMarker,
    displayRoute,
    pins,
    pinFloors,
    currentFloor,
    setupMap,
} from "./leafletMap.js";
import { lazyInit, rateLimit } from "./utils.js";

// FIXME: this should probably be in application.js or something similarly
// global, but it didn't work when we put it there
// The `lazyinit` is needed, because the `querySelector` seems to, somewhat
// randomly, block the execution of the script in our tests. This is a
// workaround, until a real solution is found.
const csrfToken = lazyInit(() => document.querySelector('meta[name="csrf-token"]').getAttribute("content"));

let currentLocation;

setupMap();
const trackingSwitch = document.getElementById("trackingSwitch");
trackingSwitch.addEventListener("click", trackingHandler);

const mapElement = $("#map")[0];
mapElement.addEventListener("click", () => {
  resolveMagicPinStrings(startInputField);
  resolveMagicPinStrings(destInputField);
});

const startInputField = $("#startInput")[0];
startInputField.addEventListener("change", () => {
  resolveMagicStrings(startInputField);
  if (!validatePlaceInput("startInput", "startOptions")) {
    startInputField.setCustomValidity("Please select a valid starting place.");
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

$("#navigationForm")[0].addEventListener("submit", (event) => {
  event.preventDefault();
  event.stopPropagation();
  let coordinates = [startInputField.value, destInputField.value];
  let floors = [0, 0]
  coordinates.forEach((routePoint, i) => {
    switch (routePoint) {
      case YOUR_LOCATION_MAGIC_STRING:
        coordinates[i] = currentLocation;
        floors[i] = currentFloor;
        break;
      case PIN_1_MAGIC_STRING:
        coordinates[i] = pinCoordinatesString(pins[0]);
        floors[i] = pinFloors[0];
        break;
      case PIN_2_MAGIC_STRING:
        coordinates[i] = pinCoordinatesString(pins[1]);
        floors[i] = pinFloors[1];
        break;
    }
  });
  displayRoute(coordinates[0], floors[0], coordinates[1], floors[1]);
});

function pinCoordinatesString(pin) {
  return (
    String(pin.getLatLng().lat.toFixed(7)) +
    "," +
    String(pin.getLatLng().lng.toFixed(7))
  );
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

function checkPinExistence(pinNumber, inputField) {
  if (!pins[pinNumber] || pins[pinNumber] === null) {
    inputField.setCustomValidity(
      "You have to click on the map to set a pin to use this feature."
    );
  } else {
    inputField.setCustomValidity("");
  }
}

function requestLocation(inputField) {
  navigator.geolocation.getCurrentPosition(
    (pos) => {
      currentLocation =
        String(pos.coords.latitude) + "," + String(pos.coords.longitude);
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
const syncUserPositionWithServer = rateLimit(syncUserPositionWithServerImpl, 10000);

let watcherId;
const positionIcon = L.icon({ iconUrl: "../assets/current-location.svg", iconSize: [30, 30], iconAnchor: [15, 15] });
const positionMarker = L.marker([0, 0], { icon: positionIcon });
positionMarker.bindPopup("Your position");

function trackingHandler() {
  if (trackingSwitch.checked) {
    addAnyMarker(positionMarker);
    watcherId = navigator.geolocation.watchPosition(
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
    navigator.geolocation.clearWatch(watcherId);
    positionMarker.remove();
  }
}
