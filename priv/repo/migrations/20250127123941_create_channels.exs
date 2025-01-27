defmodule DiscordClone.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :type, :string, null: false, default: "TEXT"

      add :profile_id, references(:profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :server_id, references(:servers, type: :binary_id, on_delete: :delete_all), null: false

      add :created_at, :utc_datetime, default: fragment("now()"), null: false
      add :updated_at, :utc_datetime, default: fragment("now()"), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:channels, [:profile_id])
    create index(:channels, [:server_id])
  end
end
