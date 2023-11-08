defmodule Journey.Analytics.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "visits" do
    field :campaign, :string
    field :city, :string
    field :client_uuid, Ecto.UUID
    field :browsing_uuid, Ecto.UUID
    field :country, :string
    field :device, :string
    field :info, :map
    field :ipaddress, :string
    field :lat, :string
    field :lon, :string
    field :page, :string
    field :hash, :string
    field :session, :string
    field :source, :string
    field :state, :string
    field :tags, :string
    field :time, :naive_datetime_usec
    field :ua, :string
    field :client_id, :id
    field :browsing_id, :id
    field :utm_campaign, :string
    field :utm_source, :string
    field :utm_medium, :string
    field :utm_term, :string
    field :utm_content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [
      :time,
      :client_id,
      :client_uuid,
      :browsing_id,
      :browsing_uuid,
      :ipaddress,
      :country,
      :state,
      :city,
      :lat,
      :lon,
      :page,
      :hash,
      :session,
      :campaign,
      :source,
      :ua,
      :device,
      :tags,
      :info,
      :utm_campaign,
      :utm_source,
      :utm_medium,
      :utm_term,
      :utm_content
    ])
  end
end
