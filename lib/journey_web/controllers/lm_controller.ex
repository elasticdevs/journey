defmodule JourneyWeb.LMController do
  use JourneyWeb, :controller

  require Logger

  alias Journey.Prospects
  alias Journey.Comms
  alias Journey.Comms.LM
  alias Journey.URLs
  alias Journey.Activities

  def index(conn, _params) do
    lms = Comms.list_lms()
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

    lm_params = Map.put(lm_params, "activity_id", activity.id)

    case Comms.create_lm(lm_params) do
      {:ok, lm} ->
        Activities.update_activity!(activity, %{lm_id: lm.id})

        conn
        |> put_flash(:info, "LM created successfully.")
        |> redirect(to: ~p"/lms/#{lm}")

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
    lm = Comms.get_lm!(id)
    render(conn, :show, lm: lm)
  end

  def edit(conn, %{"id" => id}) do
    lm = Comms.get_lm!(id)

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
    lm = Comms.get_lm!(id)

    lm_params = Map.put(lm_params, "activity_id", lm.activity.id)

    case Comms.update_lm(lm, lm_params) do
      {:ok, lm} ->
        conn
        |> put_flash(:info, "LM updated successfully.")
        |> redirect(to: ~p"/lms/#{lm}")

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
    lm = Comms.get_lm!(id)
    {:ok, _lm} = Comms.delete_lm(lm)

    conn
    |> put_flash(:info, "Lm deleted successfully.")
    |> redirect(to: ~p"/lms")
  end

  def mark_as_sent(conn, %{"id" => id}) do
    lm = Comms.get_lm!(id)

    lm |> Comms.update_lm!(%{"status" => "SENT"})
    Activities.update_activity!(lm.activity, %{status: "DONE"})
    Logger.debug("CLIENT_LM_SENT_SUCCESSFULLY")

    conn
    |> put_flash(:info, "LinkedIn Message marked as sent successfully!")
    |> redirect(to: ~p"/lms/#{lm.client_id}")
  end
end
