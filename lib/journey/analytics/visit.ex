defmodule Journey.Analytics.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "visits" do
    field :campaign, :string
    field :city, :string
    field :client_uuid, Ecto.UUID
    field :country, :string
    field :device, :string
    field :info, :map
    field :ipaddress, :string
    field :lat, :string
    field :lon, :string
    field :page, :string
    field :session, :string
    field :source, :string
    field :state, :string
    field :tags, :string
    field :time, :naive_datetime_usec
    field :ua, :string
    field :client_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [
      :time,
      :client_uuid,
      :ipaddress,
      :country,
      :state,
      :city,
      :lat,
      :lon,
      :page,
      :session,
      :campaign,
      :source,
      :ua,
      :device,
      :tags,
      :info
    ])
    |> validate_required([:client_uuid])
  end
end
