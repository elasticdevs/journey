defmodule Journey.Analytics do
  @moduledoc """
  The Analytics context.
  """

  import Ecto.Query, warn: false
  alias Journey.Repo

  alias Journey.Analytics
  alias Journey.Analytics.Browsing
  alias Journey.Analytics.Visit

  @doc """
  Returns the list of visits.

  ## Examples

      iex> list_visits()
      [%Visit{}, ...]

  """
  def list_visits do
    Repo.all(Visit)
  end

  @doc """
  Gets a single visit.

  Raises `Ecto.NoResultsError` if the Visit does not exist.

  ## Examples

      iex> get_visit!(123)
      %Visit{}

      iex> get_visit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_visit!(id), do: Repo.get!(Visit, id)

  @doc """
  Creates a visit.

  ## Examples

      iex> create_visit(%{field: value})
      {:ok, %Visit{}}

      iex> create_visit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_visit(attrs \\ %{}) do
    %Visit{}
    |> Visit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a visit.

  ## Examples

      iex> update_visit(visit, %{field: new_value})
      {:ok, %Visit{}}

      iex> update_visit(visit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_visit(%Visit{} = visit, attrs) do
    visit
    |> Visit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a visit.

  ## Examples

      iex> delete_visit(visit)
      {:ok, %Visit{}}

      iex> delete_visit(visit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_visit(%Visit{} = visit) do
    Repo.delete(visit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking visit changes.

  ## Examples

      iex> change_visit(visit)
      %Ecto.Changeset{data: %Visit{}}

  """
  def change_visit(%Visit{} = visit, attrs \\ %{}) do
    Visit.changeset(visit, attrs)
  end

  alias Journey.Analytics.Browsing

  @doc """
  Returns the list of browsings.

  ## Examples

      iex> list_browsings()
      [%Browsing{}, ...]

  """
  def list_browsings do
    Repo.all(Browsing)
  end

  @doc """
  Gets a single browsing.

  Raises `Ecto.NoResultsError` if the Browsing does not exist.

  ## Examples

      iex> get_browsing!(123)
      %Browsing{}

      iex> get_browsing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_browsing!(id), do: Repo.get!(Browsing, id)

  @doc """
  Creates a browsing.

  ## Examples

      iex> create_browsing(%{field: value})
      {:ok, %Browsing{}}

      iex> create_browsing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_browsing(attrs \\ %{}) do
    %Browsing{}
    |> Browsing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a browsing.

  ## Examples

      iex> update_browsing(browsing, %{field: new_value})
      {:ok, %Browsing{}}

      iex> update_browsing(browsing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_browsing(%Browsing{} = browsing, attrs) do
    browsing
    |> Browsing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a browsing.

  ## Examples

      iex> delete_browsing(browsing)
      {:ok, %Browsing{}}

      iex> delete_browsing(browsing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_browsing(%Browsing{} = browsing) do
    Repo.delete(browsing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking browsing changes.

  ## Examples

      iex> change_browsing(browsing)
      %Ecto.Changeset{data: %Browsing{}}

  """
  def change_browsing(%Browsing{} = browsing, attrs \\ %{}) do
    Browsing.changeset(browsing, attrs)
  end
end
