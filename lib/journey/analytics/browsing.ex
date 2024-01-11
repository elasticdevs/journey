defmodule Journey.Analytics.Browsing do
  use Ecto.Schema
  import Ecto.Changeset
  alias Journey.Prospects.Client
  alias Journey.Analytics.Visit

  schema "browsings" do
    field :browsing_uuid, Ecto.UUID
    field :last_visited_at, :utc_datetime_usec
    has_many :visits, Visit, preload_order: [desc_nulls_last: :updated_at]
    belongs_to :client, Client

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(browsing, attrs) do
    browsing
    |> cast(attrs, [:browsing_uuid, :client_id, :last_visited_at])
  end
end
