defmodule Journey.Prospects do
  @moduledoc """
  The Prospects context.
  """

  import Ecto.Query, warn: false
  alias Journey.Repo
  alias Journey.Prospects.Client
  alias Journey.Analytics.Browsing
  alias Journey.Analytics.Visit

  alias Journey.Prospects.FreshSales
  alias Journey.URLs

  @doc """
  Returns the list of clients.

  ## Examples

      iex> list_clients()
      [%Client{}, ...]

  """
  def list_clients(%{in_last_secs: in_last_secs}) do
    {clients_where, browsings_where, visits_where} =
      case in_last_secs do
        "all" ->
          {true, true, true}

        nil ->
          {true, true, true}

        _ ->
          {
            dynamic([c], ago(^in_last_secs, "second") < c.last_visited_at),
            dynamic([b], ago(^in_last_secs, "second") < b.last_visited_at),
            dynamic([v], ago(^in_last_secs, "second") < v.inserted_at)
          }
      end

    browsings_query =
      from b in Browsing,
        where: ^browsings_where

    visits_query = from v in Visit, where: ^visits_where

    Repo.all(
      from c in Client,
        where: ^clients_where,
        order_by: [desc_nulls_last: :last_visited_at],
        preload: [:url, browsings: ^{browsings_query, [visits: visits_query]}]
    )
  end

  @doc """
  Gets a single client.

  Raises `Ecto.NoResultsError` if the Client does not exist.

  ## Examples

      iex> get_client!(123)
      %Client{}

      iex> get_client!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client!(id), do: Repo.get!(Client, id)

  def get_client(%{in_last_secs: in_last_secs, id: id}) do
    {browsings_where, visits_where} =
      case in_last_secs do
        "all" ->
          {true, true}

        nil ->
          {true, true}

        _ ->
          {
            dynamic([b], ago(^in_last_secs, "second") < b.last_visited_at),
            dynamic([v], ago(^in_last_secs, "second") < v.inserted_at)
          }
      end

    browsings_query =
      from b in Browsing,
        where: ^browsings_where

    visits_query = from v in Visit, where: ^visits_where

    Repo.get(Client, id)
    |> Repo.preload(browsings: {browsings_query, [visits: visits_query]})
    |> Repo.preload(emails: :template)
    |> Repo.preload(:url)
  end

  def get_client(%{id: id}), do: Repo.get(Client, id)

  def get_client_by_client_uuid(client_uuid), do: Repo.get_by(Client, client_uuid: client_uuid)

  @doc """
  Creates a client.

  ## Examples

      iex> create_client(%{field: value})
      {:ok, %Client{}}

      iex> create_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client(attrs \\ %{}) do
    response =
      %Client{}
      |> Client.changeset(attrs)
      |> Repo.insert()

    case response do
      {:ok, c} ->
        client = get_client!(c.id)
        URLs.create_url(%{client_id: client.id, url: sponsored_link_full(client)})

        {:ok, client}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a client.

  ## Examples

      iex> update_client(client, %{field: new_value})
      {:ok, %Client{}}

      iex> update_client(client, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client(%Client{} = c, attrs) do
    client =
      c
      |> Client.changeset(attrs)
      |> Repo.update!()
      |> Repo.preload(:url)

    client.url || URLs.create_url(%{client_id: client.id, url: sponsored_link_full(client)})

    {:ok, client}
  end

  @doc """
  Deletes a client.

  ## Examples

      iex> delete_client(client)
      {:ok, %Client{}}

      iex> delete_client(client)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client changes.

  ## Examples

      iex> change_client(client)
      %Ecto.Changeset{data: %Client{}}

  """
  def change_client(%Client{} = client, attrs \\ %{}) do
    Client.changeset(client, attrs)
  end

  def sync_fresh_sales(page \\ 1) do
    contacts = FreshSales.get_contacts(page)

    Enum.each(contacts, fn c ->
      client =
        case Repo.get_by(Client, external_id: c[:external_id]) do
          nil -> %Client{}
          client -> client
        end
        |> Client.changeset(c)
        |> Repo.insert_or_update!()
        |> Repo.preload(:url)

      client.url || URLs.create_url(%{client_id: client.id, url: sponsored_link_full(client)})
    end)

    if length(contacts) > 0 do
      sync_fresh_sales(page + 1)
    end
  end

  def enum_clients_browsings(clients) do
    Enum.flat_map(clients, fn c -> c.browsings end)
  end

  def sponsored_link_full(client) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:website_url]}/?uuid=#{client.client_uuid}"
  end

  def sponsored_link_shortened(client) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:shortener_url]}/#{client.code}"
  end
end
