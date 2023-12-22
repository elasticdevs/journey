defmodule Journey.Repo.Migrations.AddHostToVisits do
  use Ecto.Migration

  def change do
    alter table(:visits) do
      add :host, :string
    end
  end
end
