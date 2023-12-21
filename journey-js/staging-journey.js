let url = location.href;
let click_event_listener_added = false;

function journey() {
  let gdpr_accepted = Cookies.get("gdpr_accepted")
  Cookies.set("gdpr_accepted", "true", { expires: 10000 })

  logVisitToJourney()

  if (!click_event_listener_added) {
    document.body.addEventListener(
      "click",
      () => {
        setTimeout(function () {
          if (url !== location.href) {
            url = location.href
            logVisitToJourney()
          }
        }, 3000)
      },
      true
    )
    click_event_listener_added = true;
  }
}

function logVisitToJourney() {
  let url = new URL(document.location)
  let params = new URLSearchParams(url.search)
  let gdpr_accepted = Cookies.get("gdpr_accepted")
  let activity_uuid = params.get("auuid")
  let browsing_uuid = Cookies.get("browsing_uuid")
  let client_uuid = Cookies.get("client_uuid") || params.get("uuid")

  let utm_campaign = params.get("utm_campaign")
  let utm_source = params.get("utm_source")
  let utm_medium = params.get("utm_medium")
  let utm_term = params.get("utm_term")
  let utm_content = params.get("utm_content")

  fetch("https://staging.elasticdevs.io/analytics/visits", {
    method: "POST",
    headers: {
      "Content-type": "application/json",
    },
    body: JSON.stringify({
      visit: {
        gdpr_accepted: gdpr_accepted,
        activity_uuid: activity_uuid,
        browsing_uuid: browsing_uuid,
        client_uuid: client_uuid,
        page: window.location.pathname,
        hash: window.location.hash,
        utm_campaign: utm_campaign,
        utm_source: utm_source,
        utm_medium: utm_medium,
        utm_term: utm_term,
        utm_content: utm_content,
      },
    }),
  })
    .then((response) => {
      if (response.ok) {
        return response.json()
      }
    })
    .then((response_json) => {
      Cookies.set("browsing_uuid", response_json.browsing_uuid, {
        expires: 10000,
      })
    })
}
