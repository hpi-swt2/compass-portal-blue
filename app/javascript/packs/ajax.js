global.ajaxCall = (event, target, valuesToSubmit = "") => {
  const applyAjaxWrap = () => {
    $("#browse-outlet a").each(function () {
      const link = $(this);
      const href = link.attr("href");
      link.attr("href", "#");
      link.on("click", (event) => {
        ajaxCall(event, href, "");
      });
    });
  };

  event.preventDefault();
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
      applyAjaxWrap();
    },
  });
};
