defmodule JourneyWeb.VisitController do
  use JourneyWeb, :controller

  alias Journey.Repo
  alias Journey.Prospects.Client
  alias Journey.Analytics
  alias Journey.Analytics.Browsing
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
    # grab headers
    headers = Enum.into(conn.req_headers, %{})

    # grab UA, and skip if the UA contains the word "bot"
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

    # grab gdpr_accepted
    gdpr_accepted = visit_params["gdpr_accepted"]

    # grab client
    client =
      try do
        Repo.get_by(Client, client_uuid: visit_params["client_uuid"])
      rescue
        _ -> nil
      catch
        _ -> nil
      end

    # grab browsing
    browsing =
      try do
        Repo.get_by(Browsing, browsing_uuid: visit_params["browsing_uuid"])
      rescue
        _ -> nil
      catch
        _ -> nil
      end

    # if client exists
    visit_params =
      case client do
        nil ->
          Map.merge(visit_params, %{
            "client_uuid" => nil
          })

        c ->
          Map.merge(visit_params, %{
            "client_id" => c.id
          })
      end

    # if browsing exists
    visit_params =
      case browsing do
        nil ->
          Map.merge(visit_params, %{
            "browsing_uuid" => nil
          })

        b ->
          Map.merge(visit_params, %{
            "browsing_id" => b.id
          })
      end

    # CASE1: gdpr=false, we just record an
    # anonymous visit on the website

    # CASE2: gdpr=true, when both client_uuid and
    # browsing_uuid didnt come
    # this means that a very new client has clicked
    # the sponsored link for the first time

    # CASE3: gdpr=true, when only client_uuid comes
    # this means that a very new client has clicked
    # the sponsored link for the first time

    # CASE4: gdpr=true, when only browsing_uuid comes
    # this means that a unknown client is visting
    # the website

    # CASE5: gdpr=true, when both client_uuid and browsing_uuid come
    # this means that a known client has clicked
    # the sponsored link

    {visit_params, browsing} =
      case {gdpr_accepted, client, browsing} do
        # CASE1
        {nil, _, _} ->
          {visit_params, browsing}

        # CASE1 repeated
        {"false", _, _} ->
          {visit_params, browsing}

        # CASE2
        {"true", nil, nil} ->
          {:ok, b} = Analytics.create_browsing(%{})
          b = Repo.get(Browsing, b.id)

          {Map.merge(visit_params, %{
             "browsing_uuid" => b.browsing_uuid,
             "browsing_id" => b.id
           }), b}

        # CASE3
        {"true", client, nil} ->
          {:ok, b} =
            Analytics.create_browsing(%{
              "client_id" => client.id
            })

          b = Repo.get(Browsing, b.id)

          {Map.merge(visit_params, %{
             "browsing_uuid" => b.browsing_uuid,
             "client_id" => client.id,
             "browsing_id" => b.id
           }), b}

        # CASE4
        {"true", nil, browsing} ->
          {Map.merge(visit_params, %{
             "browsing_id" => browsing.id
           }), browsing}

        # CASE5
        {"true", client, browsing} ->
          {Map.merge(visit_params, %{
             "client_id" => client.id,
             "browsing_id" => browsing.id
           }), browsing}
      end

    # Set status
    visit_params = Map.put(visit_params, "status", "ACTIVE")

    browsing =
      if browsing && client do
        case Analytics.update_browsing(browsing, %{
               client_id: client.id
             }) do
          {:ok, b} ->
            Repo.get(Browsing, b.id)

          {:error, %Ecto.Changeset{} = _} ->
            browsing
        end
      else
        browsing
      end

    case Analytics.create_visit(visit_params) do
      {:ok, _} ->
        if headers["content-type"] == "application/json" do
          json(conn, %{
            status: "success",
            browsing_uuid: if(browsing, do: browsing.browsing_uuid, else: nil)
          })
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
