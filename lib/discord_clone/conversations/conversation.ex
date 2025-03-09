defmodule DiscordClone.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "conversations" do
    belongs_to :member_one, DiscordClone.Members.Member, foreign_key: :member_one_id, type: :binary_id, on_replace: :delete
    belongs_to :member_two, DiscordClone.Members.Member, foreign_key: :member_two_id, type: :binary_id, on_replace: :delete

    has_many :direct_messages, DiscordClone.DirectMessages.DirectMessage

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:member_one_id, :member_two_id])
    |> validate_required([:member_one_id, :member_two_id])
    # |> validate_unique_pair(:member_one_id, :member_two_id)
    |> foreign_key_constraint(:member_one_id)
    |> foreign_key_constraint(:member_two_id)
    |> unique_constraint([:member_one_id, :member_two_id])

  end

  # defp validate_unique_pair(changeset, field_one, field_two) do
  #   query =
  #     from c in __MODULE__,
  #       where: field(c, ^field_one) == get_field(changeset, field_one) and
  #              field(c, ^field_two) == get_field(changeset, field_two)

  #   case Repo.exists?(query) do
  #     true -> add_error(changeset, :base, "This conversation already exists")
  #     false -> changeset
  #   end
  # end
end
