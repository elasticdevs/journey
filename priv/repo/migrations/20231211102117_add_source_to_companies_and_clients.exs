defmodule Journey.Repo.Migrations.AddSourceToCompaniesAndClients do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :source, :string
    end

    alter table(:clients) do
      add :source, :string
    end
  end
end
