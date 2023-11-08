defmodule Journey.Analytics.Browsing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "browsings" do
    field :browsing_uuid, Ecto.UUID
    field :client_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(browsing, attrs) do
    browsing
    |> cast(attrs, [:browsing_uuid, :client_id])
  end
end
