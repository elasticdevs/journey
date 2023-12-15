defmodule JourneyWeb.ClientController do
  use JourneyWeb, :controller

  require Logger
  alias Journey.Prospects
  alias Journey.Prospects.Client
  alias Journey.Prospects.Bulk

  def index(conn, _params) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    clients = Prospects.list_clients(%{in_last_secs: in_last_secs})
    render(conn, :index, clients: clients)
  end

  def new(conn, _params) do
    changeset = Prospects.change_client(%Client{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"client" => client_params}) do
    case Prospects.create_client(client_params) do
      {:ok, client} ->
        conn
        |> put_flash(:info, "Client created successfully.")
        |> redirect(to: ~p"/clients/#{client}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
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
    case Prospects.find_client_by_linkedin(linkedin) do
      nil ->
        Logger.debug("FIND_CLIENT_BY_LINKEDIN_NEW, linkedin=#{linkedin}")

        case Prospects.create_client_by_linkedin(linkedin) do
          {:ok, client} ->
            conn
            |> put_flash(:info, "Client / Company created successfully.")
            |> redirect(to: ~p"/clients/#{client}")

          {:error, %Ecto.Changeset{} = changeset} ->
            Logger.error(
              "FIND_CLIENT_BY_LINKEDIN_CREATE_ERROR, changeset=#{IO.inspect(changeset.errors)}"
            )

            conn
            |> put_flash(:info, "Client / Company could not be created.")
            |> redirect(to: ~p"/clients/new")
        end

      c ->
        Logger.debug("FIND_CLIENT_BY_LINKEDIN_EXISTS, linkedin=#{linkedin}")

        conn
        |> redirect(to: ~p"/clients/#{c}")
    end
  end

  def show(conn, %{"id" => id}) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    client = Prospects.get_client(%{in_last_secs: in_last_secs, id: id})

    render(conn, :show, client: client)
  end

  def edit(conn, %{"id" => id}) do
    client = Prospects.get_client!(id)
    changeset = Prospects.change_client(client)
    render(conn, :edit, client: client, changeset: changeset)
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    client = Prospects.get_client!(id)

    case Prospects.update_client(client, client_params) do
      {:ok, client} ->
        conn
        |> put_flash(:info, "Client updated successfully.")
        |> redirect(to: ~p"/clients/#{client}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, client: client, changeset: changeset)
    end
  end

  def sync_fresh_sales(conn, _) do
    Prospects.sync_fresh_sales()

    conn
    |> put_flash(:info, "Clients refreshed successfully.")
    |> redirect(to: ~p"/clients")
  end

  def delete(conn, %{"id" => id}) do
    client = Prospects.get_client!(id)
    {:ok, _client} = Prospects.delete_client(client)

    conn
    |> put_flash(:info, "Client deleted successfully.")
    |> redirect(to: ~p"/clients")
  end
end
