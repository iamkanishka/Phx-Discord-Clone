defmodule DiscordClone.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    field :file_url, :string
    field :deleted, :boolean, default: false

    belongs_to :member, YourApp.Members.Member, type: :binary_id, on_replace: :delete
    belongs_to :channel, YourApp.Channels.Channel, type: :binary_id, on_replace: :delete


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :file_url, :deleted, :member_id, :channel_id])
    |> validate_required([:content, :member_id, :channel_id])
    |> validate_length(:content, min: 1)
    |> validate_length(:file_url, max: 2048)
    |> foreign_key_constraint(:member_id)
    |> foreign_key_constraint(:channel_id)
  end
end
