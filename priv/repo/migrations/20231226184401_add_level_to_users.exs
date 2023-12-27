defmodule Journey.Repo.Migrations.AddGroupToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :level, :integer
    end
  end
end
