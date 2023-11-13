defmodule Journey.Analytics.Browsing do
  use Ecto.Schema
  import Ecto.Changeset
  alias Journey.Prospects.Client
  alias Journey.Analytics.Visit

  schema "browsings" do
    field :browsing_uuid, Ecto.UUID
    # field :client_id, :id
    belongs_to :client, Client
    has_many :visits, Visit, preload_order: [desc: :inserted_at]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(browsing, attrs) do
    browsing
    |> cast(attrs, [:browsing_uuid, :client_id])
  end
end
