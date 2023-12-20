defmodule Journey.Repo.Migrations.AddLastVisitedAtToActivities do
  use Ecto.Migration

  def change do
    alter table("activities") do
      add :last_visited_at, :utc_datetime
    end
  end
end
