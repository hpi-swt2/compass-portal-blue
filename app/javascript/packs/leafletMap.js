let map;
let routeLayer;
let layerControl;

export async function setupMap() {
    map = L.map("map");
    layerControl = L.control.layers({}).addTo(map);
    L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution:
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 22,
    }).addTo(map);

    const [view, buildingPolygons, buildingMarkers] = await Promise.all([
        getView(),
        getBuildings(),
        getBuildingMarkers(),
    ]);

    setView(view);
    addTargetMarker();
    addPolygons(buildingPolygons);
    addMarkers(buildingMarkers);

    // Add indoor labels
    loadGeoJsonFile('assets/ABC-Building-0.geojson');
    loadGeoJsonFile('assets/ABC-Building-1.geojson');
    map.on("zoomend", recalculateTooltipVisibility);
}

function addTargetMarker() {
    const params = new URLSearchParams(window.location.search);
    if (!params.has("target")) return
    const target = params.get("target");
    const coordinates = target.split(",");

    const marker = {
        latlng: coordinates,
        divIcon: {
            html: "<img src='/assets/pin.png'>",
            className: "target-pin",
        },
    };
    addMarker(marker, map);
    setView({latlng: coordinates, zoom: 19});
}

export function setView(view) {
    map.setView(view["latlng"], view["zoom"]);
}

export function addPolygons(polygons) {
    polygons.forEach((polygon) => {
        L.polygon(polygon["latlngs"], polygon["options"]).addTo(map);
    });
}

export function addMarkers(markers, layer = map) {
    markers.forEach((marker) => {
        addMarker(marker, layer);
    });
}

export function addMarker(marker, layer = map) {
    marker["divIcon"]["iconSize"] = [];
    marker["divIcon"]["iconAnchor"] = [0, 0];
    marker["divIcon"]["popupAnchor"] = [0, 0];
    const icon = L.divIcon(marker["divIcon"]);
    L.marker(marker["latlng"], { icon: icon }).addTo(layer);
}

export function addPolylines(polylines, layer = map) {
    polylines.forEach((polyline) => {
        addPolyline(polyline, layer);
    });
}

export function addPolyline(polyline, layer = map) {
    L.polyline(polyline["latlngs"], polyline["options"]).addTo(layer);
}

export async function displayRoute(start, dest) {
    const route = await $.ajax({
        type: "GET",
        url: "/building_map/route",
        data: `start=${start}&dest=${dest}`,
        dataType: "json",
    });
    if (routeLayer) routeLayer.clearLayers();
    else routeLayer = L.layerGroup();
    addPolyline(route["polyline"], routeLayer);
    addMarkers([route["marker"]], routeLayer);
    routeLayer.addTo(map);
}

async function getBuildings() {
    return $.ajax({
        type: "GET",
        url: "/building_map/buildings",
        dataType: "json",
    });
}

async function getBuildingMarkers() {
    return $.ajax({
        type: "GET",
        url: "/building_map/markers",
        dataType: "json",
    });
}

async function getView() {
    return $.ajax({
        type: "GET",
        url: "/building_map/view",
        dataType: "json",
    });
}

function addIndoorLabel(feature, layer) {
    const point = polylabel([layer._latlngs[0].map(point => {return [point.lat, point.lng]})], 0.000001, true);
    L.circleMarker({lat: point[0], lng: point[1]}, {opacity: 0, radius: 0}).bindTooltip(
        feature.properties.name, {
        permanent: true,
        direction: "center",
        className: "indoor-label",
    }).addTo(map);
}

function loadGeoJsonFile(filename) {
    fetch(filename)
        .then((response) => response.json())
        .then((geojsonFeatureCollection) => {
            // Manually add indoor labels to map
            const rooms = L.geoJSON(geojsonFeatureCollection, { filter: (f => {return f.geometry.type != "Point"}) }).addTo(map);
            const group = L.layerGroup(rooms);
            rooms.eachLayer((layer)=>{  
                const point = polylabel([layer._latlngs[0].map(point => {return [point.lat, point.lng]})], 0.000001, true);
                L.circleMarker({lat: point[0], lng: point[1]}, {opacity: 0, radius: 0}).bindTooltip(
                feature.properties.name,
                {
                    permanent: true,
                    direction:'center',
                    className: 'indoor-label',
                }
                ).addTo(map).addTo(group);
                //console.log(layer._latlngs[0].map(point => {return [point.lat, point.lng]}));
                //console.log(polylabel([layer._latlngs[0].map(point => {return [point.lat, point.lng]})], 1.0));
            });
            recalculateTooltipVisibility();
            layerControl.addBaseLayer(rooms);
        });
}

function recalculateTooltipVisibility() {
    const zoomLevel = map.getZoom();
    map.eachLayer((layer) => {
        if (layer.getTooltip()) {
            if (zoomLevel >= 19 /* nearest zoom */) {
                //layer.openTooltip()
                //layer.getTooltip().update();
            } else {
                //layer.closeTooltip()
            }
        }
    });
}
