defmodule JourneyWeb.PageController do
  alias Journey.Prospects
  alias Journey.Analytics
  use JourneyWeb, :controller

  def landing(conn, _) do
    case get_session(conn, :current_user) do
      nil ->
        conn |> render(:landing)

      _ ->
        conn |> redirect(to: ~p"/home")
    end
  end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    in_last_secs = get_in_last_secs_from_cookie(conn)

    clients = Prospects.list_clients(%{in_last_secs: in_last_secs})
    browsings = Analytics.list_browsings(%{in_last_secs: in_last_secs})
    visits = Analytics.list_visits(%{in_last_secs: in_last_secs})

    conn
    |> render(:home,
      clients: clients,
      browsings: browsings,
      visits: visits
    )
  end
end
