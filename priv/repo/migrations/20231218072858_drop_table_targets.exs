defmodule Journey.Repo.Migrations.DropTableTargets do
  use Ecto.Migration

  def change do
    drop table(:targets)
  end
end
