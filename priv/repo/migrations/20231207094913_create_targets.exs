defmodule Journey.Repo.Migrations.CreateTargets do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :notes, :string
      add :status, :string
      add :company_id, references(:companies, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:targets, [:company_id])
    create index(:targets, [:user_id])
  end
end
