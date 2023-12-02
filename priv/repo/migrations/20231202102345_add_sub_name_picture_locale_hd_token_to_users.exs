defmodule Journey.Repo.Migrations.AddSubNamePictureLocaleHdTokenToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :sub, :string
      add :name, :string
      add :picture, :string
      add :locale, :string
      add :hd, :string
      add :token, :string
    end
  end
end
