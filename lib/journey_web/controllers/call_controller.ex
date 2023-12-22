defmodule JourneyWeb.CallController do
  use JourneyWeb, :controller

  alias Journey.Prospects
  alias Journey.Comms
  alias Journey.Comms.Call
  alias Journey.Activities

  def index(conn, _params) do
    calls = Comms.list_calls()
    render(conn, :index, calls: calls)
  end

  def new(conn, %{"client_uuid" => client_uuid}) do
    case Prospects.get_client_by_client_uuid(client_uuid) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client UUID.")
        |> redirect(to: ~p"/")

      c ->
        changeset = Comms.change_call(%Call{client_id: c.id, status: "CALLED"})

        render(conn, :new,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options("CALL"),
          templates_map: Comms.templates_map("CALL")
        )
    end
  end

  def create(conn, %{"call" => call_params}) do
    current_user = conn.assigns.current_user
    client_id = call_params["client_id"]

    case Comms.create_call(call_params) do
      {:ok, call} ->
        Activities.log_call!(current_user, call)

        conn
        |> put_flash(:info, "Call created successfully.")
        |> redirect(to: ~p"/clients/#{client_id}")

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
              templates_options: Comms.templates_options("CALL"),
              templates_map: Comms.templates_map("CALL")
            )
        end
    end
  end

  def show(conn, %{"id" => id}) do
    call = Comms.get_call!(id)
    render(conn, :show, call: call)
  end

  def edit(conn, %{"id" => id}) do
    call = Comms.get_call!(id)

    case Prospects.get_client!(call.client_id) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client ID.")
        |> redirect(to: ~p"/")

      c ->
        changeset = Comms.change_call(call)

        render(conn, :edit,
          call: call,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options("CALL"),
          templates_map: Comms.templates_map("CALL")
        )
    end
  end

  def update(conn, %{"id" => id, "call" => call_params}) do
    call = Comms.get_call!(id)

    case Comms.update_call(call, call_params) do
      {:ok, call} ->
        conn
        |> put_flash(:info, "Call updated successfully.")
        |> redirect(to: ~p"/calls/#{call}")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Prospects.get_client!(call.client_id) do
          nil ->
            conn
            |> put_flash(:info, "Could not find client with the given Client ID.")
            |> redirect(to: ~p"/")

          c ->
            render(conn, :edit,
              call: call,
              changeset: changeset,
              client: c,
              templates_options: Comms.templates_options("CALL"),
              templates_map: Comms.templates_map("CALL")
            )
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    call = Comms.get_call!(id)
    {:ok, _call} = Comms.delete_call(call)

    conn
    |> put_flash(:info, "Call deleted successfully.")
    |> redirect(to: ~p"/calls")
  end
end
