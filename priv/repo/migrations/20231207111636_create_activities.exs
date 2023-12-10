defmodule Journey.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :type, :string
      add :message, :string
      add :details, :string
      add :scheduled_at, :string
      add :executed_at, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :company_id, references(:companies, on_delete: :nothing)
      add :client_id, references(:clients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:activities, [:user_id])
    create index(:activities, [:company_id])
    create index(:activities, [:client_id])
  end
end
