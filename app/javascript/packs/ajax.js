import { resetTargetMarkers, showTargetMarker } from "./leafletMap";

global.ajaxCall = (
  event,
  target,
  valuesToSubmit = "",
  canGetBack = false,
  pushToHistory = true
) => {
  const applyAjaxWrap = () => {
    $("#browse-outlet a").each(function () {
      const link = $(this);
      const href = link.attr("href");
      link.attr("href", "#");
      const [baseLink, queryParams] = href.split(/\?(.+)/);
      link.on("click", (event) => {
        ajaxCall(event, baseLink, queryParams, true);
      });
    });
  };
  event?.preventDefault();
  if (target === "/route") {
    $("#browse-outlet-container").addClass("navigation");
    const params = new URLSearchParams(valuesToSubmit);
    if (params.get("dest")) {
      $("#navigation_form #dest_input").val(params.get("dest"));
      $("#navigation_form #dest_input")[0].dispatchEvent(new Event("change"));
    }
    if (params.get("start")) {
      $("#navigation_form #start_input").val(params.get("start"));
      $("#navigation_form #start_input")[0].dispatchEvent(new Event("change"));
    }
    if (pushToHistory) {
      history.pushState(
        {
          canGetBack,
        },
        null,
        `/map${target}?${valuesToSubmit}`
      );
    }
    return;
  } else {
    if (global.routeLayer) routeLayer.clearLayers();
    $("#browse-outlet-container").removeClass("navigation");
  }
  $("#browse-outlet").html(
    '<div class="loading"><i class="fas fa-compass"></i></div>'
  );
  $.ajax({
    type: "GET",
    url: target,
    data: valuesToSubmit,
    dataType: "html",
    success: function (text) {
      const parsed = new DOMParser().parseFromString(text, "text/html");
      const content = parsed.querySelector("#app-outlet-outer");
      $("#browse-outlet").html(content.innerHTML);
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
          `/map${target}?${valuesToSubmit}`
        );
      }
    },
  });
};

function navigateToLocation(pushToHistory = false) {
  $("#_overlay").addClass("open");
  $("#toggle-overlay").addClass("visible");
  $("#toggle-overlay").addClass("open");
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
