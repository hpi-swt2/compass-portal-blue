import { resetTargetMarkers, showTargetMarker } from "./leafletMap";

/** This function is used to circumvent the browser's native navigation
 * and instead load the results of called pages (search, show) into the
 * little window (div#browse-outlet).
 */
global.ajaxCall = (
  event,
  target,
  valuesToSubmit = "",
  canGetBack = false,
  pushToHistory = true
) => {
  /** This function wraps all links in the loaded html data so that
   * they call the ajaxCall function instead of navigating to the page.
   */
  const applyAjaxWrap = () => {
    $("#browse-outlet a").each(function () {
      const link = $(this);
      const href = link.attr("href");
      if (href.match(/(mailto|tel):(.*)/)) {
        return;
      }
      // Remove the original href of the link:
      link.attr("href", "#");
      const [baseLink, queryParams] = href.split(/\?(.+)/);
      link.on("click", (event) => {
        ajaxCall(event, baseLink, queryParams, true);
      });
    });
  };
  event?.preventDefault();
  /** Special handling of all /map/route paths so that instead of loading another page,
   * the route navigation screen is shown on in the browse outlet so that a navigation can be started.
   */
  if (target === "/route") {
    $("#browse-outlet-container").addClass("navigation");
    const params = new URLSearchParams(valuesToSubmit);
    // Copy the start and dest from the url into the corresponding form fields.
    if (params.get("dest")) {
      $("#navigationForm #destInput").val(params.get("dest"));
      $("#navigationForm #destInput")[0].dispatchEvent(new Event("change"));
    }
    if (params.get("start")) {
      $("#navigationForm #startInput").val(params.get("start"));
      $("#navigationForm #startInput")[0].dispatchEvent(new Event("change"));
    }
    if (pushToHistory) {
      history.pushState(
        {
          canGetBack,
        },
        null,
        // TODO: do not hardcode this
        `/map${target}?${valuesToSubmit}${valuesToSubmit.includes('locale') ? '' : '&locale=' + I18n.locale}`
      );
    }
    return;
  } else {
    // Clear all routes if the url does not contain the route keyword, i.e. only show routes if
    // the url dictates it
    if (global.routeLayer) routeLayer.clearLayers();
    $("#browse-outlet-container").removeClass("navigation");
  }
  // Show loading animation
  $("#browse-outlet").html(
    '<div class="loading"><i class="fas fa-compass"></i></div>'
  );
  // Make a remote call to the target url (e.g. search, show, etc.)
  $.ajax({
    type: "GET",
    url: target,
    data: valuesToSubmit,
    dataType: "html",
    success: function (text) {
      // Parse received text to valid DOM elements and insert them into the #browse-outlet
      const parsed = new DOMParser().parseFromString(text, "text/html");
      const content = parsed.querySelector("#app-outlet-outer");
      $("#browse-outlet").html(content.innerHTML);

      // Retrieve all location info from a (possibly nonexistent) script tag on the
      // target page and show it on the map if it exists
      const latLongInfo = content.querySelector("#_latlonginfo");
      setTimeout(() => {
        if (latLongInfo) {
          const latlong = JSON.parse(latLongInfo.innerHTML);
          showTargetMarker(latlong);
        }
      }, 0);
      applyAjaxWrap();
      if (canGetBack) {
        $("#floating-back").addClass("visible");
      } else {
        $("#floating-back").removeClass("visible");
      }
      if (pushToHistory) {
        history.pushState(
          {
            canGetBack,
          },
          null,
          // Preserve the query parameters
          `/map${target}${target.includes('?') ? '&' : '?'}${valuesToSubmit}`
        );
      }
    },
  });
};

function navigateToLocation(pushToHistory = false) {
  $("#_overlay").addClass("open");
  $("#toggle-overlay").addClass("visible");
  $("#toggle-overlay").addClass("open");
  // Slice away the /map part of the url to find the **real** target url
  const path = location.pathname.slice(4);
  resetTargetMarkers();
  ajaxCall(
    null,
    path,
    location.search.slice(1),
    history?.state?.canGetBack ?? false,
    pushToHistory
  );
}

window.addEventListener("popstate", function (event) {
  event.preventDefault();
  const path = location.pathname;
  if (path.slice(0, 5) === "/map/") {
    navigateToLocation();
  }
});

window.addEventListener("load", function () {
  const path = location.pathname;
  if (path.slice(0, 5) === "/map/") {
    navigateToLocation(true);
  }
});
