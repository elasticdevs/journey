defmodule Journey.URLs do
  @moduledoc """
  The URLs context.
  """

  import Ecto.Query, warn: false
  alias Journey.Accounts.User
  alias Journey.Prospects.Client
  alias Journey.Repo

  alias Journey.URLs.URL

  @doc """
  Returns the list of urls.

  ## Examples

      iex> list_urls()
      [%URL{}, ...]

  """
  def list_urls(current_user) do
    Repo.all(
      from url in URL,
        left_join: c in Client,
        on:
          c.id ==
            url.client_id,
        left_join: u in User,
        on:
          u.id ==
            c.user_id,
        where:
          ^current_user.level == 0 or is_nil(u) or
            (not is_nil(u.level) and u.level >= ^current_user.level),
        order_by: [desc: :updated_at],
        preload: :client
    )
  end

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(123)
      %URL{}

      iex> get_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url!(id), do: Repo.get!(URL, id)

  def get_url_one!(current_user, id),
    do:
      Repo.one!(
        from url in URL,
          left_join: c in Client,
          on:
            c.id ==
              url.client_id,
          left_join: u in User,
          on:
            u.id ==
              c.user_id,
          where:
            (^current_user.level == 0 or is_nil(u) or
               (not is_nil(u.level) and u.level >= ^current_user.level)) and
              url.id == ^id,
          preload: :client
      )

  def get_url_by_code!(code), do: Repo.get_by!(URL, code: code) |> Repo.preload(:activity)

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %URL{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url(attrs \\ %{}) do
    %URL{}
    |> URL.create_changeset(attrs)
    |> Repo.insert()
  end

  def create_url!(attrs \\ %{}) do
    %URL{}
    |> URL.create_changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a url.

  ## Examples

      iex> update_url(url, %{field: new_value})
      {:ok, %URL{}}

      iex> update_url(url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_url(%URL{} = url, attrs) do
    url
    |> URL.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete_url(url)
      {:ok, %URL{}}

      iex> delete_url(url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url(%URL{} = url) do
    Repo.delete(url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url changes.

  ## Examples

      iex> change_url(url)
      %Ecto.Changeset{data: %URL{}}

  """
  def change_url(%URL{} = url, attrs \\ %{}) do
    URL.update_changeset(url, attrs)
  end

  def sponsored_img_url_shortened_from_url(url) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:shortener_url]}/api/img/#{url.code}"
  end
end
