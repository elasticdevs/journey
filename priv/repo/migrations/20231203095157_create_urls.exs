defmodule Journey.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :name, :string
      add :purpose, :string
      add :url, :string
      add :fallback_url, :string
      add :code, :string
      add :status, :string
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:urls, [:client_id])
  end
end
