defmodule Journey.Repo.Migrations.AddUniqueIndexesOnCompaniesAndClients do
  use Ecto.Migration

  def change do
    create unique_index(:companies, [:website])
    create unique_index(:clients, [:email])
    create unique_index(:clients, [:linkedin])
  end
end
