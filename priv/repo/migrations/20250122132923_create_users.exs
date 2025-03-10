defmodule DiscordClone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :name, :string, null: false
      add :image, :string, null: false
      add :token, :string, null: false

      timestamps()
    end

    # Ensure email is unique
    create unique_index(:users, [:email])
  end
end
