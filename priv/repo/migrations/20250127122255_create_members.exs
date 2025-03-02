defmodule DiscordClone.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      timestamps(type: :utc_datetime)
    end
  end
end
