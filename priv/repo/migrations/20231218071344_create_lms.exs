defmodule Journey.Repo.Migrations.CreateLMs do
  use Ecto.Migration

  def change do
    create table(:lms) do
      add :lm_uuid, :string, default: fragment("gen_random_uuid()")
      add :status, :string
      add :client_id, references(:clients, on_delete: :nothing)
      add :template_id, references(:templates, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:lms, [:client_id])
    create index(:lms, [:template_id])
  end
end
