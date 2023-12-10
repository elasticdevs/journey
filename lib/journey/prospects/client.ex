defmodule Journey.Prospects.Client do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Prospects.Company
  alias Journey.Analytics.Browsing
  alias Journey.Comms.Email
  alias Journey.Common.Types
  alias Journey.URLs.URL

  @derive {Jason.Encoder, only: [:client_uuid]}
  schema "clients" do
    field :city, :string
    field :client_uuid, Ecto.UUID
    field :comments, :string
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
    field :last_visited_at, :utc_datetime_usec
    has_many :browsings, Browsing, preload_order: [desc: :last_visited_at]
    has_many :emails, Email, preload_order: [desc: :updated_at]
    has_one :url, URL
    belongs_to :company, Company

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(client, attrs) do
    attrs = attrs |> remove_bad_chars

    client
    |> cast(attrs, [
      :company_id,
      :client_uuid,
      :external_id,
      :name,
      :email,
      :phone,
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

  def remove_bad_chars(changeset) do
    Enum.into(
      Enum.map(changeset, fn {k, v} ->
        {k, if(Types.typeof(v) == "string", do: String.replace(v, "\"", ""), else: v)}
      end),
      %{}
    )
  end
end
