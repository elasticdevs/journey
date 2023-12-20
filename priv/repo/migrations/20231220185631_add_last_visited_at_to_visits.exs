defmodule Journey.Repo.Migrations.AddLastVisitedAtToVisits do
  use Ecto.Migration

  def change do
    alter table("visits") do
      add :last_visited_at, :utc_datetime
    end
  end
end
