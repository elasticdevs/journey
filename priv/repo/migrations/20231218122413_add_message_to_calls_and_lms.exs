defmodule Journey.Repo.Migrations.AddMessageToCallsAndLms do
  use Ecto.Migration

  def change do
    alter table(:calls) do
      add :message, :string
    end

    alter table(:lms) do
      add :message, :string
    end
  end
end
