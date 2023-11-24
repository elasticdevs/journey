// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "../css/tacit.min.css"
import "../css/app.css"
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Feather icons
feather.replace();
// Setup copy button
$(function () {
  $(".copy").click(function () {
    let value = $(this).attr("copy-value")
    navigator.clipboard.writeText(value)
  })
})

let convert_dates = function () {
  $(".utc_to_local").html(function (index, utc_date) {
    return moment(utc_date + " +0000", "YYYY-MM-DDTHH:mm:ss.SSSSSS Z").local().format('MMM DD, LTS') + "<div class='time-ago'>" + moment(utc_date + " +0000", "YYYY-MM-DDTHH:mm:ss.SSSSSS Z").fromNow() + "</div>";
  });
};
$(document).ready(convert_dates);

$(function () {
  // Function to set the value of the select element from a cookie
  function setTimeFromCookie() {
    var selectElement = document.getElementById('in_last_secs')
    var selectedValue = getCookie('in_last_secs')

    if (selectedValue) {
      selectElement.value = selectedValue
    } else {
      setCookie('in_last_secs', "all", 10000) // Cookie will expire in x days
      setTimeFromCookie()
    }
  }
  // Function to get the value of a cookie
  function getCookie(name) {
    var value = "; " + document.cookie
    var parts = value.split("; " + name + "=")

    if (parts.length === 2) {
      return parts.pop().split(";").shift()
    }
  }

  // Function to update the cookie when the selection changes
  function updateCookie() {
    var selectElement = document.getElementById('in_last_secs')
    var selectedValue = selectElement.value
    setCookie('in_last_secs', selectedValue, 10000) // Cookie will expire in x days
    location.reload()
  }

  // Function to set a cookie
  function setCookie(name, value, days) {
    var expires = ""

    if (days) {
      var date = new Date()
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000))
      expires = "; expires=" + date.toUTCString()
    }

    document.cookie = name + "=" + value + expires + "; path=/"
  }

  // Set initial value from cookie
  setTimeFromCookie()

  // Add event listener for change event
  document.getElementById('in_last_secs').addEventListener('change', updateCookie)
})

$(function () {
  $("#search").keyup(function () {
    // Declare variables
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("search");
    filter = input.value.toLowerCase();
    table = document.getElementById("clients");
    tr = table.getElementsByTagName("tr");

    // Loop through all table rows, and hide those who don't match the search query
    count = 0;
    for (i = 0; i < tr.length; i++) {
      if (tr[i]) {
        txtValue = tr[i].textContent || tr[i].innerText;
        if (txtValue.toLowerCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
          count++;
        } else {
          tr[i].style.display = "none";
        }
      }
    }

    $("#search-count").html(count);
  })
})
$(function () {
  setTimeout(() => {
    $("#msg").addClass("hidden")
  }, 5000)
})