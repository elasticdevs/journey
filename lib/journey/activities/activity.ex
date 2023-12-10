defmodule Journey.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :details, :string
    field :executed_at, :string
    field :message, :string
    field :scheduled_at, :string
    field :status, :string
    field :type, :string
    field :user_id, :id
    field :company_id, :id
    field :client_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:type, :message, :details, :scheduled_at, :executed_at, :status])
    |> validate_required([:type, :message, :details, :scheduled_at, :executed_at, :status])
  end
end
