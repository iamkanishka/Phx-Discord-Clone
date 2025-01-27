defmodule DiscordClone.Repo.Migrations.CreateDirectMessages do
  use Ecto.Migration

  def change do
    create table(:direct_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text, null: false
      add :file_url, :text
      add :deleted, :boolean, default: false

      add :member_id, references(:members, type: :binary_id, on_delete: :delete_all), null: false
      add :conversation_id, references(:conversations, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:direct_messages, [:member_id])
    create index(:direct_messages, [:conversation_id])
  end
end
