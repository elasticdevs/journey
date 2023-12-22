defmodule Journey.Repo.Migrations.RenameHostToOriginInVisits do
  use Ecto.Migration

  def change do
    rename table("visits"), :host, to: :origin
  end
end
