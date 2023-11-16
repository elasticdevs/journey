defmodule Journey.Repo.Migrations.AddLastVisitedAtToClientsAndBrowsings do
  use Ecto.Migration

  def change do
    alter table("clients") do
      add :last_visited_at, :utc_datetime
    end
    alter table("browsings") do
      add :last_visited_at, :utc_datetime
    end
  end
end
