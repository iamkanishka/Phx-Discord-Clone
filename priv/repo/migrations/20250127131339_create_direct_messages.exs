defmodule DiscordClone.Repo.Migrations.CreateDirectMessages do
  use Ecto.Migration

  def change do
    create table(:direct_messages) do

      add :content, :text, null: false
      add :file_url, :text
      add :deleted, :boolean, default: false

      timestamps()
    end

  end
end
