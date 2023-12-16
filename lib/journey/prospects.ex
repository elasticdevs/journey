defmodule Journey.Prospects do
  @moduledoc """
  The Prospects context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias Journey.Activities
  alias Journey.Repo
  alias Journey.Prospects.Client
  alias Journey.Analytics.Browsing
  alias Journey.Analytics.Visit

  alias Journey.Prospects.FreshSales
  alias Journey.URLs
  alias Journey.ThirdParties.Apollo.API

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
        order_by: [desc_nulls_last: :last_visited_at, desc_nulls_last: :updated_at],
        preload: [:user, :company, :url, browsings: ^{browsings_query, [visits: visits_query]}]
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
  def get_client!(id), do: Repo.get!(Client, id) |> Repo.preload(:company)

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
    |> Repo.preload([:company, :url, :user])
  end

  def get_client(%{id: id}), do: Repo.get(Client, id)

  def get_client_by_client_uuid(client_uuid), do: Repo.get_by(Client, client_uuid: client_uuid)

  def find_client_by_linkedin(linkedin) do
    linkedin = linkedin |> String.trim_trailing("/")

    Repo.get_by(Client, linkedin: linkedin)
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
    response =
      %Client{}
      |> Client.changeset(attrs)
      |> Repo.insert()

    case response do
      {:ok, c} ->
        client = get_client!(c.id)
        URLs.create_url(%{client_id: client.id, url: sponsored_link_full_from_client(client)})

        {:ok, client}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_client_by_linkedin(current_user, linkedin) do
    {company_params, client_params} = API.get_company_and_client_by_linkedin(linkedin)

    # populate the current_user
    company_params = Map.put(company_params, :user_id, current_user.id)
    client_params = Map.put(client_params, :user_id, current_user.id)

    Logger.debug("CREATE_CLIENT_COMPANY_PARAMS, company_params=#{Kernel.inspect(company_params)}")
    Logger.debug("CREATE_CLIENT_PARAMS, client_params=#{Kernel.inspect(client_params)}")

    client_params =
      case find_or_create_company(company_params) do
        {:ok, c} ->
          Activities.log_user_company_linkedin_add(current_user, c)
          Map.put(client_params, :company_id, c.id)

        {:found, c} ->
          Map.put(client_params, :company_id, c.id)

        {:error, %Ecto.Changeset{} = changeset} ->
          Logger.error("FIND_OR_CREATE_COMPANY_ERROR, errors=#{Kernel.inspect(changeset)}")

          client_params
      end

    create_client(client_params)
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
    Logger.debug("CLIENT_UPDATE_ATTRS, attrs=#{Kernel.inspect(attrs)}")

    client =
      c
      |> Client.changeset(attrs)
      |> Repo.update!()
      |> Repo.preload(:url)

    client.url ||
      URLs.create_url(%{client_id: client.id, url: sponsored_link_full_from_client(client)})

    {:ok, client}
  end

  def resync_company_and_client(current_user, client) do
    {company_params, client_params} = API.get_company_and_client_by_linkedin(client.linkedin)

    # populate the current_user
    company_params = Map.put(company_params, :user_id, current_user.id)
    client_params = Map.put(client_params, :user_id, current_user.id)

    Logger.debug("RESYNC_COMPANY_PARAMS, company_params=#{Kernel.inspect(company_params)}")
    Logger.debug("RESYNC_CLIENT_PARAMS, client_params=#{Kernel.inspect(client_params)}")

    client_params =
      if company_params do
        case client.company do
          nil ->
            case find_or_create_company(company_params) do
              {:ok, c} ->
                Activities.log_user_company_resync_add(current_user, c)
                Map.put(client_params, :company_id, c.id)

              {:found, c} ->
                Map.put(client_params, :company_id, c.id)

              {:error, %Ecto.Changeset{} = changeset} ->
                Logger.error(
                  "RESYNC_FIND_OR_CREATE_COMPANY_ERROR, errors=#{Kernel.inspect(changeset)}"
                )

                client_params
            end

          co ->
            case update_company(co, company_params) do
              {:ok, _} ->
                company_params

              {:error, %Ecto.Changeset{} = changeset} ->
                Logger.error("RESYNC_COMPANY_ERROR, errors=#{Kernel.inspect(changeset)}")
                company_params
            end
        end
      else
        client_params
      end

    if client_params do
      case update_client(client, client_params) do
        {:ok, _} ->
          {:ok}

        {:error, %Ecto.Changeset{} = changeset} ->
          Logger.error(
            "RESYNC_CLIENT_ERROR_COMPANY_UPDATE_CASE, errors=#{Kernel.inspect(changeset)}"
          )

          {:error, changeset}
      end
    end
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

      client.url ||
        URLs.create_url(%{client_id: client.id, url: sponsored_link_full_from_client(client)})
    end)

    if length(contacts) > 0 do
      sync_fresh_sales(page + 1)
    end
  end

  def enum_clients_browsings(clients) do
    Enum.flat_map(clients, fn c -> c.browsings end)
  end

  def sponsored_link_full_from_client(client) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:website_url]}/?uuid=#{client.client_uuid}"
  end

  def sponsored_link_shortened_from_client(client) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:shortener_url]}/#{client.code}"
  end

  alias Journey.Prospects.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company) |> Repo.preload(:user)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  def get_company_preloaded_with_clients_browsings_visits(%{in_last_secs: in_last_secs, id: id}) do
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

    Repo.get(Company, id)
    |> Repo.preload(clients: [browsings: {browsings_query, [visits: visits_query]}])
    |> Repo.preload(:user)
  end

  def get_company_by_external_id(external_id) do
    if external_id, do: Repo.get_by(Company, external_id: external_id), else: nil
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  def find_or_create_company(company_params) do
    case get_company_by_external_id(company_params[:external_id]) do
      nil ->
        create_company(company_params)

      c ->
        {:found, c}
    end
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  alias Journey.Prospects.Target

  @doc """
  Returns the list of targets.

  ## Examples

      iex> list_targets()
      [%Target{}, ...]

  """
  def list_targets do
    Repo.all(Target)
  end

  @doc """
  Gets a single target.

  Raises `Ecto.NoResultsError` if the Target does not exist.

  ## Examples

      iex> get_target!(123)
      %Target{}

      iex> get_target!(456)
      ** (Ecto.NoResultsError)

  """
  def get_target!(id), do: Repo.get!(Target, id)

  @doc """
  Creates a target.

  ## Examples

      iex> create_target(%{field: value})
      {:ok, %Target{}}

      iex> create_target(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_target(attrs \\ %{}) do
    %Target{}
    |> Target.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a target.

  ## Examples

      iex> update_target(target, %{field: new_value})
      {:ok, %Target{}}

      iex> update_target(target, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_target(%Target{} = target, attrs) do
    target
    |> Target.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a target.

  ## Examples

      iex> delete_target(target)
      {:ok, %Target{}}

      iex> delete_target(target)
      {:error, %Ecto.Changeset{}}

  """
  def delete_target(%Target{} = target) do
    Repo.delete(target)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking target changes.

  ## Examples

      iex> change_target(target)
      %Ecto.Changeset{data: %Target{}}

  """
  def change_target(%Target{} = target, attrs \\ %{}) do
    Target.changeset(target, attrs)
  end
end
