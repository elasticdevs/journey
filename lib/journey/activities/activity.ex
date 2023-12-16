defmodule Journey.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Prospects.Client
  alias Journey.Prospects.Company
  alias Journey.Accounts.User

  schema "activities" do
    field :details, :string
    field :scheduled_at, :utc_datetime_usec
    field :executed_at, :utc_datetime_usec
    field :message, :string
    field :status, :string
    field :type, :string
    belongs_to :company, Company
    belongs_to :client, Client
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [
      :user_id,
      :company_id,
      :client_id,
      :type,
      :message,
      :details,
      :scheduled_at,
      :executed_at,
      :status
    ])
    |> validate_required([:user_id, :type, :status])
  end
end
