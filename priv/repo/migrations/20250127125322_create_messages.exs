defmodule DiscordClone.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text, null: false
      add :file_url, :text
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end
  end
end
