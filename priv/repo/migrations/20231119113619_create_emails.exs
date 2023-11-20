defmodule Journey.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add :email_uuid, :uuid, default: fragment("gen_random_uuid()")
      add :read_tracking, :boolean, default: false, null: false
      add :status, :string
      add :template_id, references(:templates, on_delete: :nothing)
      add :to_client_id, references(:clients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:emails, [:template_id])
    create index(:emails, [:to_client_id])
  end
end
