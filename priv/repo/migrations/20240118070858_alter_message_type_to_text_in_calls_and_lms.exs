defmodule Journey.Repo.Migrations.AlterMessageTypeToTextInCallsAndLms do
  use Ecto.Migration

  def change do
    alter table(:calls) do
      modify :message, :text
    end

    alter table(:lms) do
      modify :message, :text
    end
  end
end
