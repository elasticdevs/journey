defmodule JourneyWeb.PageController do
  alias Journey.Prospects
  alias Journey.Analytics
  use JourneyWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    count_clients = length(Prospects.list_clients())
    count_browsings = length(Analytics.list_browsings())
    count_visits = length(Analytics.list_visits())

    render(conn, :home,
      count_clients: count_clients,
      count_browsings: count_browsings,
      count_visits: count_visits
    )
  end
end
