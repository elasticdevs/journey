defmodule Journey.Repo.Migrations.AddActivityToVisits do
  use Ecto.Migration

  def change do
    alter table(:visits) do
      add :activity_uuid, :uuid
      add :activity_id, references(:activities, on_delete: :nothing)
    end
  end
end
