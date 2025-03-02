defmodule DiscordClone.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset


  schema "profiles" do
    field :name, :string
    field :image_url, :string
    field :email, :string

    belongs_to :user_id, DiscordClone.Accounts.User

    has_many :servers, DiscordClone.Servers.Server
    has_many :members, DiscordClone.Members.Member
    has_many :channels, DiscordClone.Channels.Channel

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:user_id, :name, :image_url, :email])
    |> validate_required([:user_id, :name, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:user_id)
  end
end
