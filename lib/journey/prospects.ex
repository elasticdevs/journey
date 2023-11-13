defmodule Journey.Prospects do
  @moduledoc """
  The Prospects context.
  """

  import Ecto.Query, warn: false
  alias Journey.Repo
  alias Journey.Prospects.Client
  alias Journey.Analytics.Browsing
  alias Journey.Analytics.Visit

  @doc """
  Returns the list of clients.

  ## Examples

      iex> list_clients()
      [%Client{}, ...]

  """
  def list_clients(%{in_last_secs: in_last_secs}) do
    in_last_secs = in_last_secs || 315_360_000

    browsings_query =
      from b in Browsing,
        distinct: b.id,
        join: v in assoc(b, :visits),
        where: ago(^in_last_secs, "second") < v.inserted_at

    visits_query = from v in Visit, where: ago(^in_last_secs, "second") < v.inserted_at

    Repo.all(
      from c in Client,
        distinct: c.id,
        join: b in assoc(c, :browsings),
        join: v in assoc(b, :visits),
        where: ago(^in_last_secs, "second") < v.inserted_at,
        order_by: [desc: v.inserted_at]
    )
    |> Repo.preload(browsings: {browsings_query, [visits: visits_query]})
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
  def get_client(%{in_last_secs: in_last_secs, id: id}) do
    in_last_secs = in_last_secs || 315_360_000

    browsings_query =
      from b in Browsing,
        distinct: b.id,
        join: v in assoc(b, :visits),
        where: ago(^in_last_secs, "second") < v.inserted_at

    visits_query = from v in Visit, where: ago(^in_last_secs, "second") < v.inserted_at

    Repo.get(Client, id) |> Repo.preload(browsings: {browsings_query, [visits: visits_query]})
  end

  @doc """
  Creates a client.

  ## Examples

      iex> create_client(%{field: value})
      {:ok, %Client{}}

      iex> create_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client(attrs \\ %{}) do
    %Client{}
    |> Client.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client.

  ## Examples

      iex> update_client(client, %{field: new_value})
      {:ok, %Client{}}

      iex> update_client(client, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client(%Client{} = client, attrs) do
    client
    |> Client.changeset(attrs)
    |> Repo.update()
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
end
