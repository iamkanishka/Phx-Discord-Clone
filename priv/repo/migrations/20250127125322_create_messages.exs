defmodule DiscordClone.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text
      add :file_url, :text
      add :file_type, :text
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end
  end
end
