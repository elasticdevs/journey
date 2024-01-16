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
    current_user = conn.assigns.current_user

    companies_all = Prospects.list_companies()
    companies = Prospects.list_companies(current_user)

    clients_all = Prospects.list_clients(current_user, %{in_last_secs: "all"})
    clients = Prospects.list_clients(current_user, %{in_last_secs: in_last_secs})

    visits_all = Analytics.list_visits(current_user, %{in_last_secs: "all", type: "WEB"})
    visits = Analytics.list_visits(current_user, %{in_last_secs: in_last_secs})

    activities_all = Activities.list_activities(current_user, %{in_last_secs: "all"})
    activities = Activities.list_activities(current_user, %{in_last_secs: in_last_secs})

    browsings = Analytics.list_browsings(current_user, %{in_last_secs: in_last_secs})

    conn
    |> render(:home,
      companies_all: companies_all,
      companies: companies,
      clients_all: clients_all,
      clients: clients,
      visits_all: visits_all,
      visits: visits,
      activities_all: activities_all,
      activities: activities,
      browsings: browsings,
      in_last_secs_string: in_last_secs_string
    )
  end
end
