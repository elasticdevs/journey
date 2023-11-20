defmodule Journey.Repo.Migrations.AlterToClientIdToClientIdInEmails do
  use Ecto.Migration

  def change do
    rename table("emails"), :to_client_id, to: :client_id
  end
end
