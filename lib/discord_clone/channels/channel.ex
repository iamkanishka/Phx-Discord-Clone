defmodule DiscordClone.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "channels" do
    field :name, :string
    field :type, Ecto.Enum, values: [:TEXT, :VOICE], default: :TEXT

    belongs_to :profile, DiscordClone.Profiles.Profile, type: :binary_id, on_replace: :delete
    belongs_to :server, DiscordClone.Servers.Server, type: :binary_id, on_replace: :delete

    has_many :messages, DiscordClone.Messages.Message


    timestamps(type: :utc_datetime)
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
