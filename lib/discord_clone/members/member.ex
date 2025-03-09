defmodule DiscordClone.Members.Member do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "members" do
    field :role, Ecto.Enum, values: [:GUEST, :USER, :ADMIN], default: :GUEST

    belongs_to :profile, DiscordClone.Profiles.Profile, type: :binary_id, on_replace: :delete
    belongs_to :server, DiscordClone.Servers.Server, type: :binary_id, on_replace: :delete

    has_many :messages, DiscordClone.Messages.Message
    has_many :direct_messages, DiscordClone.Messages.DirectMessage

    has_many :conversations_initiated, DiscordClone.Conversations.Conversation, foreign_key: :member_one_id
    has_many :conversations_received, DiscordClone.Conversations.Conversation, foreign_key: :member_two_id


    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role, :profile_id, :server_id])
    |> validate_required([:role, :profile_id, :server_id])
    |> validate_inclusion(:role, [:GUEST, :USER, :ADMIN])
    |> foreign_key_constraint(:profile_id)
    |> foreign_key_constraint(:server_id)
  end
end
