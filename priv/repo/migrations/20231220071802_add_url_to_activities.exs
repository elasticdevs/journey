defmodule Journey.Repo.Migrations.AddUrlToActivities do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :url_id, references(:urls, on_delete: :nothing)
    end
  end
end
