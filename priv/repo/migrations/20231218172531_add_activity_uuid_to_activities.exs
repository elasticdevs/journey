defmodule Journey.Repo.Migrations.AddActivityUuidToActivities do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :activity_uuid, :uuid, default: fragment("gen_random_uuid()")
    end
  end
end
