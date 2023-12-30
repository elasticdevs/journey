defmodule JourneyWeb.PageController do
  alias Journey.Common.Helpers
  alias Journey.Activities
  alias Journey.Prospects
  alias Journey.Analytics
  use JourneyWeb, :controller

  def landing(conn, _) do
    case conn.assigns.current_user do
      nil ->
        conn |> render(:landing)

      _ ->
        conn |> redirect(to: ~p"/home")
    end
  end

  def home(conn, _params) do
    in_last_secs = get_in_last_secs_from_cookie(conn)
    in_last_secs_string = Helpers.map_in_last_secs_to_string(in_last_secs)

    companies = Prospects.list_companies()

    clients_all = Prospects.list_clients(conn.assigns.current_user, %{in_last_secs: "all"})
    visits_all = Analytics.list_visits(conn.assigns.current_user, %{in_last_secs: "all"})
    activities_all = Activities.list_activities(conn.assigns.current_user, %{in_last_secs: "all"})

    clients = Prospects.list_clients(conn.assigns.current_user, %{in_last_secs: in_last_secs})
    browsings = Analytics.list_browsings(conn.assigns.current_user, %{in_last_secs: in_last_secs})
    visits = Analytics.list_visits(conn.assigns.current_user, %{in_last_secs: in_last_secs})

    activities =
      Activities.list_activities(conn.assigns.current_user, %{in_last_secs: in_last_secs})

    conn
    |> render(:home,
      companies: companies,
      clients_all: clients_all,
      visits_all: visits_all,
      activities_all: activities_all,
      clients: clients,
      browsings: browsings,
      visits: visits,
      activities: activities,
      in_last_secs_string: in_last_secs_string
    )
  end
end
