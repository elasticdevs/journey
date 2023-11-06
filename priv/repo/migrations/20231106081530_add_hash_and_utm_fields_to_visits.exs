defmodule Journey.Repo.Migrations.AddHashAndUtmFieldsToVisits do
  use Ecto.Migration

  def change do
    alter table("visits") do
      add :hash, :string
      add :utm_campaign, :string
      add :utm_source, :string
      add :utm_medium, :string
      add :utm_term, :string
      add :utm_content, :string
    end
  end
end
