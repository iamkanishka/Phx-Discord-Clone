defmodule DiscordClone.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :image_url, :text, null: false
      add :invite_code, :string, null: false

      timestamps()
    end
  end
end
