defmodule Journey.Repo.Migrations.AddTypeToVisits do
  use Ecto.Migration

  def change do
    alter table(:visits) do
      add :type, :string
    end
  end
end
