defmodule Journey.Repo.Migrations.AddCommTypeToTemplates do
  use Ecto.Migration

  def change do
    alter table(:templates) do
      add :comm_type, :string
    end
  end
end
