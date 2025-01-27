defmodule DiscordClone.DirectMessages.DirectMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "direct_messages" do
    field :content, :string
    field :file_url, :string
    field :deleted, :boolean, default: false

    belongs_to :member, DiscordClone.Members.Member, foreign_key: :member_id, type: :binary_id, on_replace: :delete
    belongs_to :conversation, DiscordClone.Conversations.Conversation, foreign_key: :conversation_id, type: :binary_id, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(direct_message, attrs) do
    direct_message
    |> cast(attrs, [:content, :file_url, :member_id, :conversation_id, :deleted])
    |> validate_required([:content, :member_id, :conversation_id])
    |> foreign_key_constraint(:member_id)
    |> foreign_key_constraint(:conversation_id)
  end
end
