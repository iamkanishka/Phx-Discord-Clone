defmodule DiscordClone.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string, null: false, default: "GUEST"

      add :profile_id, references(:profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :server_id, references(:servers, type: :binary_id, on_delete: :delete_all), null: false

      add :created_at, :utc_datetime, default: fragment("now()"), null: false
      add :updated_at, :utc_datetime, default: fragment("now()"), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:members, [:profile_id])
    create index(:members, [:server_id])
  end
end
