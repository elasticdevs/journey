defmodule Journey.Repo.Migrations.AddSeniorityToClients do
  alias Journey.Prospects.Client
  use Ecto.Migration

  def change do
    alter table(:clients) do
      add :seniority, :string
    end
  end
end
