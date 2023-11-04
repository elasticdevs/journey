defmodule JourneyWeb.VisitController do
  use JourneyWeb, :controller

  alias Journey.Repo
  alias Journey.Prospects.Client
  alias Journey.Analytics
  alias Journey.Analytics.Visit

  def index(conn, _params) do
    visits = Analytics.list_visits()
    render(conn, :index, visits: visits)
  end

  def new(conn, _params) do
    changeset = Analytics.change_visit(%Visit{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"visit" => visit_params}) do
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
    visit_params = Map.put(visit_params, "status", "ACTIVE")

    visit_params =
      try do
        client = Repo.get_by(Client, client_uuid: visit_params["client_uuid"])

        if client == nil do
          Map.put(visit_params, "client_id", 1)
        else
          Map.put(visit_params, "client_id", client.id)
        end
      catch
        _ -> Map.put(visit_params, "client_id", 1)
      rescue
        _ -> Map.put(visit_params, "client_id", 1)
      end

    headers = Enum.into(conn.req_headers, %{})

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
