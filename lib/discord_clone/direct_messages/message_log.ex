defmodule DiscordClone.DirectMessages.MessageLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "message_logs" do
    belongs_to :message, DiscordClone.DirectMessages.DirectMessage, type: :binary_id
    belongs_to :member, DiscordClone.Members.Member, type: :binary_id

    field :action, :string  # "edited", "deleted", "restored"
    field :old_content, :string

    timestamps()
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:message_id, :member_id, :action, :old_content])
    |> validate_required([:message_id, :member_id, :action])
  end
end
