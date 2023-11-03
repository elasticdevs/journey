defmodule Journey.Repo.Migrations.SetupTimescaledb do
  use Ecto.Migration

  import Timescale.Migration

  def up do
    create_timescaledb_extension()
  end

  def down do
    drop_timescaledb_extension()
  end
end
