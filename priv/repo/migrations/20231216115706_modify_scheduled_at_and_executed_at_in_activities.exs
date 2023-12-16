defmodule Journey.Repo.Migrations.ModifyScheduledAtAndExecutedAtInActivities do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      remove :scheduled_at
      remove :executed_at
    end

    alter table(:activities) do
      add :scheduled_at, :utc_datetime_usec
      add :executed_at, :utc_datetime_usec
    end
  end
end
