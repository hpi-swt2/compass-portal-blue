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
      link.on("click", (event) => {
        ajaxCall(event, href, "", true);
      });
    });
  };
  event?.preventDefault();
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
      $("#browse-outlet").html(
        parsed.querySelector("#app-outlet-outer").innerHTML
      );
      if (pushToHistory) {
        history.pushState(
          {
            canGetBack,
          },
          null,
          `/map${target}?${valuesToSubmit}`
        );
      }
      applyAjaxWrap();
      if (canGetBack) {
        $("#floating-back").addClass("visible");
      } else {
        $("#floating-back").removeClass("visible");
      }
    },
  });
};

function navigateToLocation(pushToHistory = false) {
  $("#_overlay").addClass("open");
  $("#toggle-overlay").addClass("visible");
  $("#toggle-overlay").addClass("open");
  const path = location.pathname.slice(4);
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
