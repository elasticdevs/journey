defmodule Journey.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string
      add :text, :text
      add :read_tracking, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
