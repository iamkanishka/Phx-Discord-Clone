defmodule DiscordClone.Members.Member do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "members" do
    field :role, Ecto.Enum, values: [:GUEST, :USER, :ADMIN], default: :GUEST

    belongs_to :profile, YourApp.Profiles.Profile, type: :binary_id, on_replace: :delete
    belongs_to :server, YourApp.Servers.Server, type: :binary_id, on_replace: :delete

    has_many :messages, YourApp.Messages.Message
    has_many :direct_messages, YourApp.Messages.DirectMessage

    has_many :conversations_initiated, YourApp.Conversations.Conversation, foreign_key: :member_one_id
    has_many :conversations_received, YourApp.Conversations.Conversation, foreign_key: :member_two_id


    timestamps(type: :utc_datetime)
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
