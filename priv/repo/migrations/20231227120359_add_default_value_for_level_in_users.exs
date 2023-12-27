defmodule Journey.Repo.Migrations.AddDefaultValueForLevelInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :level, :integer, default: 9999
    end
  end
end
