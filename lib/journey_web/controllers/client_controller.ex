defmodule JourneyWeb.ClientController do
  use JourneyWeb, :controller

  require Logger
  alias Journey.Accounts
  alias Journey.Activities
  alias Journey.Prospects
  alias Journey.Prospects.Client
  alias Journey.Prospects.Bulk

  def index(conn, _params) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    clients = Prospects.list_clients(conn.assigns.current_user, %{in_last_secs: in_last_secs})
    render(conn, :index, clients: clients)
  end

  def new(conn, _params) do
    changeset = Prospects.change_client(%Client{})
    users_options = Accounts.users_options(conn.assigns.current_user)
    render(conn, :new, changeset: changeset, users_options: users_options)
  end

  def create(conn, %{"client" => client_params}) do
    current_user = conn.assigns.current_user

    case Prospects.create_client(client_params) do
      {:ok, client} ->
        Activities.log_manual_client_add!(current_user, client)

        conn
        |> put_flash(:info, "Client created successfully.")
        |> redirect(to: ~p"/clients/#{client}")

      {:error, %Ecto.Changeset{} = changeset} ->
        users_options = Accounts.users_options(conn.assigns.current_user)
        render(conn, :new, changeset: changeset, users_options: users_options)
    end
  end

  def bulk(conn, _params) do
    bulk = %Bulk{}
    types = %{external_ids: :string}
    attrs = %{}
    changeset = {bulk, types} |> Ecto.Changeset.cast(attrs, Map.keys(types))
    render(conn, :bulk, changeset: changeset)
  end

  def linkedin(conn, %{"linkedin" => linkedin}) do
    current_user = conn.assigns.current_user

    case Prospects.find_client_by_linkedin(linkedin) do
      nil ->
        Logger.debug("FIND_CLIENT_BY_LINKEDIN_NEW, linkedin=#{linkedin}")

        case Prospects.create_client_by_linkedin(current_user, linkedin) do
          {:ok, client} ->
            Activities.log_linkedin_client_add!(current_user, client)

            conn
            |> put_flash(:info, "Client / Company created successfully.")
            |> redirect(to: ~p"/clients/#{client}")

          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error("FIND_CLIENT_BY_LINKEDIN_CREATE_ERROR, changeset=#{inspect(changeset)}")

            conn
            |> put_flash(:info, "Client / Company could not be created.")
            |> redirect(to: ~p"/clients/new")
        end

      c ->
        Logger.debug("FIND_CLIENT_BY_LINKEDIN_EXISTS, linkedin=#{linkedin}")

        conn
        |> put_flash(:info, "Client is already a part of Journey.")
        |> redirect(to: ~p"/clients/#{c}")
    end
  end

  def show(conn, %{"id" => id}) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    client =
      Prospects.get_client_one!(conn.assigns.current_user, %{in_last_secs: in_last_secs, id: id})

    render(conn, :show, client: client)
  end

  def edit(conn, %{"id" => id}) do
    client = Prospects.get_client_one!(conn.assigns.current_user, %{id: id})
    users_options = Accounts.users_options(conn.assigns.current_user)

    changeset = Prospects.change_client(client)
    render(conn, :edit, client: client, changeset: changeset, users_options: users_options)
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    client = Prospects.get_client_one!(conn.assigns.current_user, %{id: id})

    case Prospects.update_client(client, client_params) do
      {:ok, client} ->
        conn
        |> put_flash(:info, "Client updated successfully.")
        |> redirect(to: ~p"/clients/#{client}")

      {:error, %Ecto.Changeset{} = changeset} ->
        users_options = Accounts.users_options(conn.assigns.current_user)
        render(conn, :edit, client: client, changeset: changeset, users_options: users_options)
    end
  end

  def resync(conn, %{"client_id" => client_id}) do
    client =
      Prospects.get_client_one!(conn.assigns.current_user, %{
        id: client_id
      })

    current_user = conn.assigns.current_user

    case Prospects.resync_company_and_client(current_user, client) do
      {:ok} ->
        conn
        |> put_flash(:info, "Company and Client resynced successfully.")
        |> redirect(to: ~p"/clients/#{client}")

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:info, "Company and Client resynced failed.")
        |> redirect(to: ~p"/clients/#{client}")
    end
  end

  def sync_fresh_sales(conn, _) do
    Prospects.sync_fresh_sales()

    conn
    |> put_flash(:info, "Clients refreshed successfully.")
    |> redirect(to: ~p"/clients")
  end

  def delete(conn, %{"id" => id}) do
    client = Prospects.get_client_one!(conn.assigns.current_user, %{id: id})

    {:ok, _client} = Prospects.delete_client(client)

    conn
    |> put_flash(:info, "Client deleted successfully.")
    |> redirect(to: ~p"/clients")
  end
end
