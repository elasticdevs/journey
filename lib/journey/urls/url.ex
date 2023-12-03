defmodule Journey.URLs.URL do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :code, :string
    field :fallback_url, :string
    field :name, :string
    field :purpose, :string
    field :status, :string
    field :url, :string
    field :client_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:name, :purpose, :url, :fallback_url, :code, :status])
    |> validate_required([:name, :purpose, :url, :fallback_url, :code, :status])
  end
end
