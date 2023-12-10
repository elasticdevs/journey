defmodule Journey.Repo.Migrations.RemoveCompanyAndAddCompanyIdAndTypeToClients do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      remove :company
      add :company_id, references(:companies), null: true
      add :type, :string
    end
  end
end
