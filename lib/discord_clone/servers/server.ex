defmodule DiscordClone.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id
  schema "servers" do
    field :name, :string
    field :image_url, :string
    field :invite_code, :string

    belongs_to :profile, DiscordClone.Profiles.Profile
    has_many :members, DiscordClone.Members.Member
    has_many :channels, DiscordClone.Channels.Channel

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :image_url, :invite_code, :profile_id])
    |> validate_required([:name, :image_url, :invite_code, :profile_id])
    |> unique_constraint(:invite_code)
  end
end
