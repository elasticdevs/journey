defmodule JourneyWeb.PageController do
  alias Journey.Prospects
  alias Journey.Analytics
  use JourneyWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    in_last_secs = get_in_last_secs_from_cookie(conn)

    clients = Prospects.list_clients()
    browsings = Analytics.list_browsings(%{in_last_secs: in_last_secs})
    visits = Analytics.list_visits(%{in_last_secs: in_last_secs})

    count_browsings_by_country_city =
      Analytics.count_browsings_by_country_city(%{in_last_secs: in_last_secs})

    # count_browings_by_country = Enum.reduce()

    render(conn, :home,
      clients: clients,
      browsings: browsings,
      visits: visits
    )
  end
end
