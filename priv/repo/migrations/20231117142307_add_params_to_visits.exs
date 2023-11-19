defmodule Journey.Repo.Migrations.AddParamsToVisits do
  use Ecto.Migration

  def change do
    alter table("visits") do
      add :params, :map
    end
  end
end
