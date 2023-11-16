defmodule Journey.Prospects.Client do
  use Ecto.Schema
  import Ecto.Changeset
  alias Journey.Analytics.Browsing

  @derive {Jason.Encoder, only: [:client_uuid]}
  schema "clients" do
    field :city, :string
    field :client_uuid, Ecto.UUID
    field :comments, :string
    field :company, :string
    field :country, :string
    field :email, :string
    field :external_id, :string
    field :job_title, :string
    field :linkedin, :string
    field :name, :string
    field :phone, :string
    field :state, :string
    field :status, :string
    field :tags, :string
    field :last_visited_at, :utc_datetime
    has_many :browsings, Browsing, preload_order: [desc: :last_visited_at]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [
      :client_uuid,
      :external_id,
      :name,
      :email,
      :phone,
      :company,
      :linkedin,
      :job_title,
      :country,
      :state,
      :city,
      :comments,
      :tags,
      :status,
      :last_visited_at
    ])
    |> validate_required([:external_id])
    |> unique_constraint(:client_uuid)
  end
end
