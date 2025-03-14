defmodule DiscordClone.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "channels" do
    field :name, :string
    field :type, Ecto.Enum, values: [:TEXT, :AUDIO, :VIDEO], default: :TEXT

    belongs_to :profile, DiscordClone.Profiles.Profile, on_replace: :delete
    belongs_to :server, DiscordClone.Servers.Server, on_replace: :delete

    has_many :messages, DiscordClone.Messages.Message

    timestamps()
  end


  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :type, :profile_id, :server_id])
    |> validate_required([:name, :type, :profile_id, :server_id])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_inclusion(:type, [:TEXT, :VOICE])
    |> foreign_key_constraint(:profile_id)
    |> foreign_key_constraint(:server_id)
  end
end
