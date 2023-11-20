defmodule Journey.Repo.Migrations.AlterFieldTextToBodyInTemplatesAndEmails do
  use Ecto.Migration

  def change do
    rename table("templates"), :text, to: :body
    rename table("emails"), :text, to: :body
  end
end
