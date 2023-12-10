defmodule Journey.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :user_id, references(:users)
      add :company_uuid, :uuid, default: fragment("gen_random_uuid()")
      add :name, :string
      add :website, :string
      add :funding, :string
      add :founded_year, :string
      add :team_size, :string
      add :industries, :string
      add :annual_revenue, :string
      add :market_cap, :string
      add :phone, :string
      add :linkedin, :string
      add :logo, :string
      add :country, :string
      add :state, :string
      add :city, :string
      add :lat, :string
      add :lon, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
