defmodule DiscordClone.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string, null: false, default: "GUEST"

      timestamps()
    end
  end
end
