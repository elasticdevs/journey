defmodule Journey.Repo.Migrations.AlterColumnsLastVisitedAtToUtcDatetimeUsec do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      modify :last_visited_at, :utc_datetime_usec
    end

    alter table(:browsings) do
      modify :last_visited_at, :utc_datetime_usec
    end
  end
end
