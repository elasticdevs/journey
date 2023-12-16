defmodule Journey.Prospects.Company do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Accounts.User
  alias Journey.Prospects.Client

  @derive {Jason.Encoder, only: [:company_uuid]}
  schema "companies" do
    field :annual_revenue, :string
    field :city, :string
    field :company_uuid, Ecto.UUID
    field :country, :string
    field :founded_year, :string
    field :funding, :string
    field :industries, :string
    field :lat, :string
    field :linkedin, :string
    field :logo, :string
    field :lon, :string
    field :market_cap, :string
    field :name, :string
    field :phone, :string
    field :state, :string
    field :status, :string
    field :team_size, :string
    field :website, :string
    field :source, :string
    field :external_id, :string
    has_many :clients, Client, preload_order: [:inserted_at]
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [
      :user_id,
      :name,
      :website,
      :funding,
      :founded_year,
      :team_size,
      :industries,
      :annual_revenue,
      :market_cap,
      :phone,
      :linkedin,
      :logo,
      :country,
      :state,
      :city,
      :lat,
      :lon,
      :status,
      :source,
      :external_id
    ])
    |> clean_up()
    |> validate_required([
      :linkedin
    ])
    |> unique_constraint(:linkedin)
  end

  def clean_up(changeset) do
    case get_change(changeset, :linkedin) do
      nil ->
        changeset

      linkedin ->
        changeset
        |> change(linkedin: String.trim_trailing(linkedin, "/"))
    end
  end
end
