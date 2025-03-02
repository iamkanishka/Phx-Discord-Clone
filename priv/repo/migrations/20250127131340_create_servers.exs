defmodule DiscordClone.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string, null: false
      add :image_url, :text, null: false
      add :invite_code, :string, null: false

      timestamps()
    end
  end
end
