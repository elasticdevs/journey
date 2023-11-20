defmodule Journey.Repo.Migrations.AddTextToEmails do
  use Ecto.Migration

  def change do
    alter table(:emails) do
      add :text, :text
    end
  end
end
