defmodule Journey.Repo.Migrations.AddGdprToVisits do
  use Ecto.Migration

  def change do
    alter table("visits") do
      add :gdpr, :boolean, default: false
    end
  end
end
