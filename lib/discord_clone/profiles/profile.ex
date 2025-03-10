defmodule DiscordClone.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id
  schema "profiles" do
    belongs_to :user, DiscordClone.Accounts.User

    has_many :servers, DiscordClone.Servers.Server
    has_many :members, DiscordClone.Members.Member
    has_many :channels, DiscordClone.Channels.Channel

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> unique_constraint(:user_id)
    |> assoc_constraint(:user)
  end
end
