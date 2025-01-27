defmodule DiscordClone.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :member_one_id, references(:members, type: :binary_id, on_delete: :delete_all), null: false
      add :member_two_id, references(:members, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:conversations, [:member_two_id])

    create unique_index(:conversations, [:member_one_id, :member_two_id], name: :unique_member_pair)
  end
end
