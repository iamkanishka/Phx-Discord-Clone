defmodule DiscordClone.Profiles.Profile do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :user_id, :string
    field :name, :string
    field :image_url, :string
    field :email, :string

    has_many :servers, YourApp.Servers.Server
    has_many :members, YourApp.Members.Member
    has_many :channels, YourApp.Channels.Channel


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
