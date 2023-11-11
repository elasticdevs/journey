defmodule JourneyWeb.PageController do
  alias Journey.Prospects
  alias Journey.Analytics
  use JourneyWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    in_last_days = conn.req_cookies["in_last_days"]

    clients = Prospects.list_clients()
    browsings = Analytics.list_browsings(%{in_last_days: in_last_days})
    visits = Analytics.list_visits(%{in_last_days: in_last_days})

    render(conn, :home,
      clients: clients,
      browsings: browsings,
      visits: visits
    )
  end
end
