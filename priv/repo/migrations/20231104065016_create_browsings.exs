defmodule Journey.Repo.Migrations.CreateBrowsings do
  use Ecto.Migration

  def change do
    create table(:browsings) do
      add :browsing_uuid, :uuid, default: fragment("gen_random_uuid()")
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:browsings, [:browsing_uuid])
    create index(:browsings, [:client_id])
  end
end
