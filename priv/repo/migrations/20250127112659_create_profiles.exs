defmodule DiscordClone.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string, null: false
      add :image_url, :text
      add :email, :text, null: false

      timestamps()
    end
  end
end
