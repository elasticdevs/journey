defmodule Journey.Repo.Migrations.AddExternalIdToCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :external_id, :string
    end
  end
end
