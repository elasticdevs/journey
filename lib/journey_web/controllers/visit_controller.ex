defmodule JourneyWeb.VisitController do
  use JourneyWeb, :controller
  require Logger

  alias Journey.Repo
  alias Journey.Prospects
  alias Journey.Prospects.Client
  alias Journey.Analytics
  alias Journey.Analytics.Browsing
  alias Journey.Analytics.Visit

  def index(conn, _params) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    visits = Analytics.list_visits(%{in_last_secs: in_last_secs})
    render(conn, :index, visits: visits)
  end

  def new(conn, _params) do
    changeset = Analytics.change_visit(%Visit{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"visit" => visit_params}) do
    # grab params first thing
    visit_params = Map.put(visit_params, "params", visit_params)

    # grab headers
    headers = Enum.into(conn.req_headers, %{})

    # grab UA, and skip if the UA contains the word "bot"
    ua = headers["user-agent"]
    visit_params = Map.put(visit_params, "ua", ua)

    if String.match?(ua, ~r/bot/i) || String.match?(ua, ~r/headless/i) do
      Logger.debug("BOT_IGNORED_SUCCESSFULLY, ua=#{ua}")

      if headers["content-type"] == "application/json" do
        json(conn, %{
          status: "success",
          message: "Bot ignored successfully."
        })
      else
        conn
        |> put_flash(:info, "Visit ignored successfully.")
        |> redirect(to: ~p"/visits")
      end
    else
      # grab IP address and geolocation data
      remote_ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()

      visit_params =
        case GeoIP.lookup(remote_ip) do
          {:ok, geoip} ->
            Map.merge(visit_params, %{
              "country" => geoip.country_code,
              "state" => geoip.region_name,
              "city" => geoip.city_name,
              "lat" => :erlang.float_to_binary(geoip.latitude, decimals: 2),
              "lon" => :erlang.float_to_binary(geoip.longitude, decimals: 2)
            })

          _ ->
            visit_params
        end

      visit_params = Map.put(visit_params, "ipaddress", remote_ip)

      # grab gdpr_accepted
      gdpr_accepted = visit_params["gdpr_accepted"]

      visit_params =
        if gdpr_accepted && String.match?(gdpr_accepted, ~r/true/i) do
          Map.put(visit_params, "gdpr", true)
        else
          Map.put(visit_params, "gdpr", false)
        end

      # clean browsing_uuid
      visit_params =
        case UUID.info(visit_params["browsing_uuid"]) do
          {:ok, _} ->
            visit_params

          {:error, _} ->
            Map.put(visit_params, "browsing_uuid", nil)
        end

      # clean client_uuid
      visit_params =
        case UUID.info(visit_params["client_uuid"]) do
          {:ok, _} ->
            visit_params

          {:error, _} ->
            Map.put(visit_params, "client_uuid", nil)
        end

      # grab browsing
      browsing =
        try do
          Repo.get_by(Browsing, browsing_uuid: visit_params["browsing_uuid"])
          |> Repo.preload(:client)
        rescue
          _ -> nil
        catch
          _ -> nil
        end

      # if browsing exists
      visit_params =
        case browsing do
          nil ->
            visit_params

          b ->
            Map.merge(visit_params, %{
              "browsing_id" => b.id
            })
        end

      # grab client, we trust browsing's client over whats coming in params
      client =
        try do
          (browsing && browsing.client) ||
            Repo.get_by(Client, client_uuid: visit_params["client_uuid"])
        rescue
          _ -> nil
        catch
          _ -> nil
        end

      # if client exists
      visit_params =
        case client do
          nil ->
            visit_params

          c ->
            Map.merge(visit_params, %{
              "client_id" => c.id
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
            Logger.debug("CASE1: country=#{visit_params["country"]}")
            {visit_params, browsing}

          # CASE1.1
          {"false", _, _} ->
            Logger.debug("CASE1.1_REPEATED: country=#{visit_params["country"]}")
            {visit_params, browsing}

          # CASE2
          {"true", nil, nil} ->
            {:ok, b} = Analytics.create_browsing(%{})
            b = Repo.get(Browsing, b.id)
            Logger.debug("CASE2_BOTH_MISSING: created a browsing, b.id=#{b.id}")

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
            Logger.debug("CASE3_CLIENT_EXISTS: created a browsing, b.id=#{b.id}")

            {Map.merge(visit_params, %{
               "browsing_uuid" => b.browsing_uuid,
               "client_id" => client.id,
               "browsing_id" => b.id
             }), b}

          # CASE4
          {"true", nil, browsing} ->
            Logger.debug("CASE4_BROWSING_EXISTS: browsing.id=#{browsing.id}")

            {Map.merge(visit_params, %{
               "browsing_id" => browsing.id
             }), browsing}

          # CASE5
          {"true", client, browsing} ->
            Logger.debug("CASE5_BOTH_EXISTS: client.id=#{client.id}, browsing.id=#{browsing.id}")

            {Map.merge(visit_params, %{
               "client_id" => client.id,
               "browsing_id" => browsing.id
             }), browsing}
        end

      # Set status
      visit_params = Map.put(visit_params, "status", "ACTIVE")

      case Analytics.create_visit(visit_params) do
        {:ok, v} ->
          # Update browsing
          client =
            if browsing do
              attrs =
                if client && !browsing.client_id do
                  %{
                    client_id: client.id,
                    last_visited_at: v.inserted_at
                  }
                else
                  %{
                    last_visited_at: v.inserted_at
                  }
                end

              case Analytics.update_browsing(browsing, attrs) do
                {:ok, b} ->
                  Analytics.get_browsing!(b.id).client

                {:error, _} ->
                  client
              end
            else
              client
            end

          # Update client
          if client do
            Prospects.update_client(client, %{
              last_visited_at: v.inserted_at
            })
          end

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
