defmodule DiscordClone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: true
      add :name, :string, null: true
      add :image, :string
      add :token, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email]) # Ensure email is unique
  end
end
