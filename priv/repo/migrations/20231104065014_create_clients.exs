defmodule Journey.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :client_uuid, :uuid, default: fragment("gen_random_uuid()")
      add :external_id, :string
      add :name, :string
      add :email, :string
      add :phone, :string
      add :company, :string
      add :linkedin, :string
      add :job_title, :string
      add :country, :string
      add :state, :string
      add :city, :string
      add :comments, :string
      add :tags, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:clients, [:client_uuid])
  end
end
