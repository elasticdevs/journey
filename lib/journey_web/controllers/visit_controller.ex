defmodule JourneyWeb.VisitController do
  use JourneyWeb, :controller

  alias Journey.Repo
  alias Journey.Prospects.Client
  alias Journey.Analytics
  alias Journey.Analytics.Visit

  def index(conn, _params) do
    require IEx
    IEx.pry()

    visits = Analytics.list_visits()
    render(conn, :index, visits: visits)
  end

  def new(conn, _params) do
    changeset = Analytics.change_visit(%Visit{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"visit" => visit_params}) do
    # grab headers
    headers = Enum.into(conn.req_headers, %{})

    # grab UA
    visit_params = Map.put(visit_params, "ua", headers["user-agent"])

    # grab IP address and geolocation data
    remote_ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()

    visit_params =
      case GeoIP.lookup(remote_ip) do
        {:ok, geoip} ->
          Map.merge(visit_params, %{
            "country" => geoip.country_code,
            "state" => geoip.region_name,
            "city" => geoip.city_name,
            "lat" => Float.to_string(geoip.latitude, decimals: 2),
            "lon" => Float.to_string(geoip.longitude, decimals: 2)
          })

        _ ->
          visit_params
      end

    visit_params = Map.put(visit_params, "ipaddress", remote_ip)

    # grab client
    default_client = Repo.get(Client, 1)

    client =
      try do
        c = Repo.get_by(Client, client_uuid: visit_params["client_uuid"])

        if c == nil do
          default_client
        else
          c
        end
      rescue
        _ -> default_client
      catch
        _ -> default_client
      end

    visit_params =
      Map.merge(visit_params, %{
        "client_id" => client.id,
        "client_uuid" => client.client_uuid
      })

    # Set status
    visit_params = Map.put(visit_params, "status", "ACTIVE")

    case Analytics.create_visit(visit_params) do
      {:ok, _} ->
        if headers["content-type"] == "application/json" do
          json(conn, %{status: "success"})
        else
          conn
          |> put_flash(:info, "Visit created successfully.")
          |> redirect(to: ~p"/visits")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        if headers["content-type"] == "application/json" do
          json(conn, %{status: "error"})
        else
          render(conn, :new, changeset: changeset)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    visit = Analytics.get_visit!(id)
    render(conn, :show, visit: visit)
  end

  def edit(conn, %{"id" => id}) do
    visit = Analytics.get_visit!(id)
    changeset = Analytics.change_visit(visit)
    render(conn, :edit, visit: visit, changeset: changeset)
  end

  def update(conn, %{"id" => id, "visit" => visit_params}) do
    visit = Analytics.get_visit!(id)

    case Analytics.update_visit(visit, visit_params) do
      {:ok, visit} ->
        conn
        |> put_flash(:info, "Visit updated successfully.")
        |> redirect(to: ~p"/visits/#{visit}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, visit: visit, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    visit = Analytics.get_visit!(id)
    {:ok, _visit} = Analytics.delete_visit(visit)

    conn
    |> put_flash(:info, "Visit deleted successfully.")
    |> redirect(to: ~p"/visits")
  end
end
