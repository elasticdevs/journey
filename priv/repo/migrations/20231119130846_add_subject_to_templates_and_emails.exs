defmodule Journey.Repo.Migrations.AddSubjectToTemplatesAndEmails do
  use Ecto.Migration

  def change do
    alter table(:templates) do
      add :subject, :string
    end

    alter table(:emails) do
      add :subject, :string
    end
  end
end
