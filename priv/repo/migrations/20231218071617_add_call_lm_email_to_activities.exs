defmodule Journey.Repo.Migrations.AddCallLMEmailToActivities do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :call_id, references(:calls, on_delete: :nothing)
      add :lm_id, references(:lms, on_delete: :nothing)
      add :email_id, references(:emails, on_delete: :nothing)
    end
  end
end
