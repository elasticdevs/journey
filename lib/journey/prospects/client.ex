defmodule Journey.Prospects.Client do
  use Ecto.Schema
  import Ecto.Changeset

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
      :status
    ])
    |> validate_required([:external_id])
    |> unique_constraint(:client_uuid)
  end
end
