defmodule DiscordClone.Repo.Migrations.AlterTablesAndCreateIndex do
  use Ecto.Migration

  def change do
    # Members

    alter table(:members) do
      add :profile_id, references(:profiles, type: :binary_id, on_delete: :delete_all),
        null: false

      add :server_id, references(:servers, type: :binary_id, on_delete: :delete_all), null: false
    end

    # Channels

    alter table(:channels) do
      add :profile_id, references(:profiles, type: :binary_id, on_delete: :delete_all),
        null: false

      add :server_id, references(:servers, type: :binary_id, on_delete: :delete_all), null: false
    end

    # Messages
    alter table(:messages) do
      add :member_id, references(:members, type: :binary_id, on_delete: :delete_all), null: false

      add :channel_id, references(:channels, type: :binary_id, on_delete: :delete_all),
        null: false
    end

    # conversations
    alter table(:conversations) do
      add :member_one_id, references(:members, type: :binary_id, on_delete: :delete_all),
        null: false

      add :member_two_id, references(:members, type: :binary_id, on_delete: :delete_all),
        null: false
    end

    # Direct Messages
    alter table(:direct_messages) do
      add :member_id, references(:members, type: :binary_id, on_delete: :delete_all), null: false

      add :conversation_id, references(:conversations, type: :binary_id, on_delete: :delete_all),
        null: false
    end

    # Servers

    alter table(:servers) do
      add :profile_id, references(:profiles, type: :binary_id, on_delete: :delete_all),
        null: false
    end

    ##### Indexes

    # Profiles
    create unique_index(:profiles, [:user_id])

    # Members
    create index(:members, [:profile_id])
    create index(:members, [:server_id])

    # Servers
    create unique_index(:servers, [:invite_code])
    create index(:servers, [:profile_id])

    # Channels

    create index(:channels, [:profile_id])
    create index(:channels, [:server_id])

    # Messages

    create index(:messages, [:channel_id])
    create index(:messages, [:member_id])

    # conversation

    create index(:conversations, [:member_two_id])

    create unique_index(:conversations, [:member_one_id, :member_two_id],
             name: :unique_member_pair
           )

    # Direct Messages

    create index(:direct_messages, [:member_id])
    create index(:direct_messages, [:conversation_id])
  end
end
