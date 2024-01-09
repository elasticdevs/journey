defmodule JourneyWeb.LMController do
  use JourneyWeb, :controller

  require Logger

  alias Journey.Prospects
  alias Journey.Comms
  alias Journey.Comms.LM
  alias Journey.URLs
  alias Journey.Activities

  def index(conn, _params) do
    lms = Comms.list_lms(conn.assigns.current_user)
    render(conn, :index, lms: lms)
  end

  def new(conn, %{"client_uuid" => client_uuid}) do
    case Prospects.get_client_by_client_uuid(client_uuid) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client UUID.")
        |> redirect(to: ~p"/")

      c ->
        changeset = Comms.change_lm(%LM{client_id: c.id, status: "DRAFT"})

        render(conn, :new,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options("LM"),
          templates_map: Comms.templates_map("LM")
        )
    end
  end

  def create(conn, %{"lm" => lm_params}) do
    current_user = conn.assigns.current_user
    client_id = lm_params["client_id"]

    activity = Activities.log_lm!(current_user, client_id)
    activity = Activities.get_activity!(activity.id)

    url =
      URLs.create_url!(%{
        client_id: client_id,
        url: Activities.sponsored_link_full_from_activity(activity)
      })

    Activities.update_activity!(activity, %{url_id: url.id})

    lm_params = Map.merge(lm_params, %{"activity_id" => activity.id, "status" => "DRAFT"})

    case Comms.create_lm(lm_params) do
      {:ok, lm} ->
        Activities.update_activity!(activity, %{lm_id: lm.id})

        conn
        |> put_flash(:info, "LM created successfully.")
        |> redirect(to: ~p"/clients/#{client_id}/?section=lms")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Prospects.get_client!(changeset.changes.client_id) do
          nil ->
            conn
            |> put_flash(:info, "Could not find client with the given Client ID.")
            |> redirect(to: ~p"/")

          c ->
            render(conn, :new,
              changeset: changeset,
              client: c,
              templates_options: Comms.templates_options("LM"),
              templates_map: Comms.templates_map("LM")
            )
        end
    end
  end

  def show(conn, %{"id" => id}) do
    lm = Comms.get_lm_one!(conn.assigns.current_user, id)
    render(conn, :show, lm: lm)
  end

  def edit(conn, %{"id" => id}) do
    lm = Comms.get_lm_one!(conn.assigns.current_user, id)

    case Prospects.get_client!(lm.client_id) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client ID.")
        |> redirect(to: ~p"/")

      c ->
        changeset = Comms.change_lm(lm)

        render(conn, :edit,
          lm: lm,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options("LM"),
          templates_map: Comms.templates_map("LM")
        )
    end
  end

  def update(conn, %{"id" => id, "lm" => lm_params}) do
    lm = Comms.get_lm_one!(conn.assigns.current_user, id)
    lm_params = Map.merge(lm_params, %{"activity_id" => lm.activity.id, "status" => "DRAFT"})

    case Comms.update_lm(lm, lm_params) do
      {:ok, lm} ->
        conn
        |> put_flash(:info, "LM updated successfully.")
        |> redirect(to: ~p"/clients/#{lm.client.id}/?section=lms")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Prospects.get_client!(lm.client_id) do
          nil ->
            conn
            |> put_flash(:info, "Could not find client with the given Client ID.")
            |> redirect(to: ~p"/")

          c ->
            render(conn, :edit,
              lm: lm,
              changeset: changeset,
              client: c,
              templates_options: Comms.templates_options("LM"),
              templates_map: Comms.templates_map("LM")
            )
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    lm = Comms.get_lm_one!(conn.assigns.current_user, id)
    {:ok, _lm} = Comms.delete_lm(lm)

    conn
    |> put_flash(:info, "LM deleted successfully.")
    |> redirect(to: ~p"/lms")
  end

  def package(conn, %{"id" => id}) do
    lm = Comms.get_lm_one!(conn.assigns.current_user, id)
    current_user = conn.assigns.current_user

    lm = lm |> Map.put(:activity_id, lm.activity.id)
    processed_lm = lm |> LM.process_vars()

    lm = lm |> Comms.update_lm!(%{message: processed_lm.message, status: "PACKAGED"})

    Activities.update_activity!(lm.activity, %{
      type: "LM_PACKAGED",
      user_id: current_user.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    })

    Logger.debug("CLIENT_LM_PACKAGED_SUCCESSFULLY")

    conn
    |> put_flash(:info, "LM packaged successfully!")
    |> redirect(to: ~p"/clients/#{lm.client_id}/?section=lms")
  end

  def send(conn, %{"id" => id}) do
    lm = Comms.get_lm_one!(conn.assigns.current_user, id)
    current_user = conn.assigns.current_user

    lm = lm |> Map.put(:activity_id, lm.activity.id)
    lm = lm |> Comms.update_lm!(%{status: "SENT"})

    Activities.update_activity!(lm.activity, %{
      type: "LM_SENT",
      user_id: current_user.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    })

    Logger.debug("CLIENT_LM_SENT_SUCCESSFULLY")

    conn
    |> redirect(external: lm.client.linkedin)
  end
end
