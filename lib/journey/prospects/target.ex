defmodule Journey.Prospects.Target do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Prospects.Company
  alias Journey.Accounts.User

  schema "targets" do
    field :notes, :string
    field :status, :string
    belongs_to :company, Company
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(target, attrs) do
    target
    |> cast(attrs, [:company_id, :user_id, :notes, :status])
    |> validate_required([:notes, :status])
  end
end
