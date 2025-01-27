defmodule DiscordClone.Repo.Migrations.CreateMessages do
  use Ecto.Migration

   use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text, null: false
      add :file_url, :text
      add :deleted, :boolean, default: false, null: false

      add :member_id, references(:members, type: :binary_id, on_delete: :delete_all), null: false
      add :channel_id, references(:channels, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:channel_id])
    create index(:messages, [:member_id])
  end
  end
