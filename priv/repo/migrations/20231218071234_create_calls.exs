defmodule Journey.Repo.Migrations.CreateCalls do
  use Ecto.Migration

  def change do
    create table(:calls) do
      add :call_uuid, :string, default: fragment("gen_random_uuid()")
      add :status, :string
      add :client_id, references(:clients, on_delete: :nothing)
      add :template_id, references(:templates, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:calls, [:client_id])
    create index(:calls, [:template_id])
  end
end
