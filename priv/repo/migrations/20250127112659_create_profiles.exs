defmodule DiscordClone.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string, null: false
      add :name, :string, null: false
      add :image_url, :text
      add :email, :text, null: false

      add :created_at, :utc_datetime, default: fragment("now()"), null: false
      add :updated_at, :utc_datetime, default: fragment("now()"), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:profiles, [:user_id])
  end
end
