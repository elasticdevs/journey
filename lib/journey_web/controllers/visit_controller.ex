defmodule JourneyWeb.VisitController do
  use JourneyWeb, :controller
  require Logger

  alias Journey.Repo
  alias Journey.Prospects
  alias Journey.Prospects.Client
  alias Journey.Analytics
  alias Journey.Analytics.Browsing
  alias Journey.Analytics.Visit
  alias Journey.Activities
  alias Journey.Activities.Activity

  def index(conn, _params) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    visits = Analytics.list_visits(conn.assigns.current_user, %{in_last_secs: in_last_secs})
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

    # set last_visited_at
    last_visited_at = DateTime.now!("Etc/UTC")

    # grab origin
    visit_params =
      Map.put(visit_params, "origin", Enum.at(Plug.Conn.get_req_header(conn, "origin"), 0))

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

      # clean activity_uuid
      visit_params =
        case UUID.info(visit_params["activity_uuid"]) do
          {:ok, _} ->
            visit_params

          {:error, _} ->
            Map.put(visit_params, "activity_uuid", nil)
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

      # grab activity
      activity =
        try do
          Repo.get_by!(Activity, activity_uuid: visit_params["activity_uuid"])
          |> Repo.preload(:client)
        rescue
          _ -> nil
        catch
          _ -> nil
        end

      # grab browsing
      browsing =
        try do
          visit_params["browsing_uuid"] &&
            (Repo.get_by(Browsing, browsing_uuid: visit_params["browsing_uuid"])
             |> Repo.preload(:client) ||
               Analytics.create_browsing!(%{
                 "browsing_uuid" => visit_params["browsing_uuid"],
                 "last_visited_at" => last_visited_at
               }))
        rescue
          _ -> nil
        catch
          _ -> nil
        end

      # grab client, we trust browsing's client over whats coming in params
      client =
        try do
          (browsing && browsing.client) || (activity && activity.client) ||
            Repo.get_by(Client, client_uuid: visit_params["client_uuid"])
        rescue
          _ -> nil
        catch
          _ -> nil
        end

      # if activity exists
      visit_params =
        case activity do
          nil ->
            visit_params

          b ->
            Map.merge(visit_params, %{
              "activity_id" => b.id
            })
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

      # Set status
      visit_params = Map.put(visit_params, "status", "ACTIVE")

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

      browsing =
        case {gdpr_accepted, client, browsing, activity} do
          # CASE1
          {nil, _, _, _} ->
            Logger.debug("CASE1, country=#{visit_params["country"]}")
            visit_params = Map.put(visit_params, "last_visited_at", last_visited_at)
            Analytics.create_visit!(visit_params)
            nil

          # CASE1.1
          {"false", _, _, _} ->
            Logger.debug("CASE1.1_REPEATED, gdpr=false, country=#{visit_params["country"]}")
            visit_params = Map.put(visit_params, "last_visited_at", last_visited_at)
            Analytics.create_visit!(visit_params)
            nil

          # CASE2
          {"true", nil, nil, nil} ->
            Logger.debug("CASE2_ABC_MISSING, gdpr=true")
            browsing = Analytics.create_browsing!(%{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "browsing_id" => browsing.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing

          # CASE3
          {"true", client, nil, nil} ->
            Logger.debug("CASE3_ONLY_CLIENT_EXISTS, gdpr=true, client.id=#{client.id}")

            browsing =
              Analytics.create_browsing!(%{
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Prospects.update_client!(client, %{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "browsing_id" => browsing.id,
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing

          # CASE4
          {"true", nil, browsing, nil} ->
            Logger.debug("CASE4_ONLY_BROWSING_EXISTS, browsing.id=#{browsing.id}")

            browsing =
              Analytics.update_browsing!(browsing, %{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "browsing_id" => browsing.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing

          # CASE4.1, most likely this wont happen ever since if activity
          # exists, client would have been grabbed from it anyways
          {"true", nil, nil, activity} ->
            Logger.debug("CASE4.1_ONLY_ACTIVITY_EXISTS: activity.id=#{activity.id}")
            Activities.update_activity!(activity, %{"last_visited_at" => last_visited_at})

            browsing =
              Analytics.create_browsing!(%{
                "client_id" => activity.client.id,
                "last_visited_at" => last_visited_at
              })

            Prospects.update_client!(activity.client, %{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "activity_id" => activity.id,
                "browsing_id" => browsing.id,
                "client_id" => activity.client.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing

          # CASE5
          {"true", client, browsing, nil} ->
            Logger.debug("CASE5_BC_EXISTS: client.id=#{client.id}, browsing.id=#{browsing.id}")

            browsing =
              Analytics.update_browsing!(browsing, %{
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Prospects.update_client!(client, %{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "client_id" => client.id,
                "browsing_id" => browsing.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing

          # CASE6
          {"true", client, nil, activity} ->
            Logger.debug("CASE6_CA_EXISTS: client.id=#{client.id}, activity.id=#{activity.id}")
            Activities.update_activity!(activity, %{"last_visited_at" => last_visited_at})

            browsing =
              Analytics.create_browsing!(%{
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Prospects.update_client!(client, %{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "activity_id" => activity.id,
                "browsing_id" => browsing.id,
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing

          # CASE7
          {"true", nil, browsing, activity} ->
            Logger.debug(
              "CASE7_BA_EXISTS: browsing.id=#{browsing.id}, activity.id=#{activity.id}"
            )

            Activities.update_activity!(activity, %{"last_visited_at" => last_visited_at})

            browsing =
              Analytics.update_browsing!(browsing, %{
                "client_id" => activity.client.id,
                "last_visited_at" => last_visited_at
              })

            Prospects.update_client!(activity.client, %{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "activity_id" => activity.id,
                "browsing_id" => browsing.id,
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing

          # CASE8
          {"true", client, browsing, activity} ->
            Logger.debug("CASE8_ABC_EXISTS: client.id=#{client.id}, browsing.id=#{browsing.id}")
            Activities.update_activity!(activity, %{"last_visited_at" => last_visited_at})

            browsing =
              Analytics.update_browsing!(browsing, %{
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Prospects.update_client!(client, %{"last_visited_at" => last_visited_at})

            visit_params =
              Map.merge(visit_params, %{
                "activity_id" => activity.id,
                "browsing_id" => browsing.id,
                "client_id" => client.id,
                "last_visited_at" => last_visited_at
              })

            Analytics.create_visit!(visit_params)
            browsing
        end

      browsing = if browsing, do: Analytics.get_browsing!(browsing.id), else: nil

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
    end
  end

  def show(conn, %{"id" => id}) do
    visit = Analytics.get_visit_one!(conn.assigns.current_user, id)
    render(conn, :show, visit: visit)
  end

  def edit(conn, %{"id" => id}) do
    visit = Analytics.get_visit_one!(conn.assigns.current_user, id)
    changeset = Analytics.change_visit(visit)
    render(conn, :edit, visit: visit, changeset: changeset)
  end

  def update(conn, %{"id" => id, "visit" => visit_params}) do
    visit = Analytics.get_visit_one!(conn.assigns.current_user, id)

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
    visit = Analytics.get_visit_one!(conn.assigns.current_user, id)
    {:ok, _visit} = Analytics.delete_visit(visit)

    conn
    |> put_flash(:info, "Visit deleted successfully.")
    |> redirect(to: ~p"/visits")
  end
end
