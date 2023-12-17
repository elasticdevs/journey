defmodule Journey.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Journey.Repo

  alias Journey.Activities.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(from a in Activity, order_by: [desc_nulls_last: a.executed_at])
    |> Repo.preload([:user, :company, :client])
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
  def get_activity!(id), do: Repo.get!(Activity, id)

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

  def log_user_login(user) do
    activity_params = %{
      user_id: user.id,
      type: "LOGIN",
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end

  def log_user_logout(user) do
    activity_params = %{
      user_id: user.id,
      type: "LOGOUT",
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end

  def log_user_company_manual_add(user, company) do
    activity_params = %{
      user_id: user.id,
      type: "COMPANY_MANUAL_ADD",
      company_id: company.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end

  def log_user_client_manual_add(user, client) do
    activity_params = %{
      user_id: user.id,
      type: "CLIENT_MANUAL_ADD",
      client_id: client.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end

  def log_user_company_linkedin_add(user, company) do
    activity_params = %{
      user_id: user.id,
      type: "COMPANY_LINKEDIN_ADD",
      company_id: company.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end

  def log_user_client_linkedin_add(user, client) do
    activity_params = %{
      user_id: user.id,
      type: "CLIENT_LINKEDIN_ADD",
      client_id: client.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end

  def log_user_company_resync_add(user, company) do
    activity_params = %{
      user_id: user.id,
      type: "COMPANY_RESYNC_ADD",
      company_id: company.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end

  def log_user_email_sent(user, email) do
    activity_params = %{
      user_id: user.id,
      type: "EMAIL_SENT",
      client_id: email.client.id,
      executed_at: DateTime.now!("Etc/UTC"),
      status: "DONE"
    }

    create_activity(activity_params)
  end
end
