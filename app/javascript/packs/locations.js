import { addMarker, setupMap, setView, addMarker } from "./leafletMap.js";

setupMap();

// Need to get this data with javascript instead of ruby!
/*setView({
          latlng: [@location.location_latitude, @location.location_longitude],
          zoom: 18,
        }); */

// addMarker(Locations.transform_leaflet_position([@location.location_latitude, @location.location_longitude], @location.name)));
