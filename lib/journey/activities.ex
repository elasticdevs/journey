defmodule Journey.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  require Logger

  alias Journey.Repo
  alias Journey.Activities.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities(%{in_last_secs: in_last_secs}) do
    activities_where =
      case in_last_secs do
        "all" ->
          true

        nil ->
          true

        _ ->
          dynamic([a], ago(^in_last_secs, "second") < a.inserted_at)
      end

    Activity
    |> where(^activities_where)
    |> order_by(desc_nulls_last: :executed_at)
    |> preload([:user, :company, :client])
    |> preload([:call, :lm, :email])
    |> Repo.all()
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id),
    do: Repo.get!(Activity, id) |> Repo.preload([:user, :company, :client, :url])

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  def create_activity!(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  def update_activity!(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  def sponsored_link_full_from_activity(activity) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:website_url]}/?auuid=#{activity.activity_uuid}"
  end

  def sponsored_link_shortened_from_activity(activity) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:shortener_url]}/#{activity.url.code}"
  end

  def log_user_login!(user) do
    activity_params = %{
      user_id: user.id,
      type: "LOGIN",
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity!(activity_params)
  end

  def log_user_logout!(user) do
    activity_params = %{
      user_id: user.id,
      type: "LOGOUT",
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity!(activity_params)
  end

  def log_manual_company_add!(user, company) do
    activity_params = %{
      user_id: user.id,
      type: "COMPANY_MANUAL_ADD",
      company_id: company.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity!(activity_params)
  end

  def log_manual_client_add!(user, client) do
    activity_params = %{
      user_id: user.id,
      type: "CLIENT_MANUAL_ADD",
      client_id: client.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity!(activity_params)
  end

  def log_linkedin_company_add!(user, company) do
    activity_params = %{
      user_id: user.id,
      type: "COMPANY_LINKEDIN_ADD",
      company_id: company.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity!(activity_params)
  end

  def log_linkedin_client_add!(user, client) do
    activity_params = %{
      user_id: user.id,
      type: "CLIENT_LINKEDIN_ADD",
      client_id: client.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity!(activity_params)
  end

  def log_resync_company_add!(user, company) do
    activity_params = %{
      user_id: user.id,
      type: "COMPANY_RESYNC_ADD",
      company_id: company.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity!(activity_params)
  end

  def log_call!(user, call) do
    activity_params = %{
      user_id: user.id,
      type: "CALLED",
      client_id: call.client_id,
      call_id: call.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    Logger.debug("LOG_USER_CLIENT_CALL, activity_params=#{inspect(activity_params)}")
    create_activity!(activity_params)
  end

  def log_lm!(user, client_id) do
    activity_params = %{
      user_id: user.id,
      type: "LMED",
      client_id: client_id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    Logger.debug("LOG_USER_LMED, activity_params=#{inspect(activity_params)}")
    create_activity!(activity_params)
  end

  def log_email!(user, client_id) do
    activity_params = %{
      user_id: user.id,
      type: "EMAILED",
      client_id: client_id,
      # email_id: email.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    Logger.debug("LOG_USER_EMAILED, activity_params=#{inspect(activity_params)}")
    create_activity!(activity_params)
  end
end
