defmodule Journey.Repo.Migrations.CreateVisits do
  use Ecto.Migration
  import Timescale.Migration

  def change do
    create table(:visits, primary_key: false) do
      add :time, :naive_datetime_usec, default: fragment("now()"), primary_key: true
      add :client_uuid, :uuid
      add :browsing_uuid, :uuid
      add :ipaddress, :string
      add :country, :string
      add :state, :string
      add :city, :string
      add :lat, :string
      add :lon, :string
      add :page, :string
      add :session, :string
      add :campaign, :string
      add :source, :string
      add :ua, :string
      add :device, :string
      add :tags, :string
      add :info, :map
      add :client_id, references(:clients, on_delete: :nothing)
      add :browsing_id, references(:browsings, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create_hypertable(:visits, :time)
    create index(:visits, [:time, :client_id, :browsing_id])
  end
end
