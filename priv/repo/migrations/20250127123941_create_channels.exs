defmodule DiscordClone.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string, null: false
      add :type, :string, null: false, default: "TEXT"

      timestamps()
    end
  end
end
