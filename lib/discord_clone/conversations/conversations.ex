defmodule DiscordClone.Conversations.Conversations do
  import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Conversations.Conversation

  @doc """
  Finds an existing conversation between two members, or creates a new one if none exists.
  Ensures that member order does not affect retrieval.
  """
  def get_or_create_conversation(member_one_id, member_two_id) do
    case find_conversation(member_one_id, member_two_id) ||
           find_conversation(member_two_id, member_one_id) do
      nil -> create_conversation(member_one_id, member_two_id)
      conversation -> {:ok, conversation}
    end
  end

  @doc """
  Finds a conversation between two members in a specific order.
  Returns `nil` if no conversation is found.
  """
  defp find_conversation(member_one_id, member_two_id) do
    Repo.one(
      from c in Conversation,
        where: c.member_one_id == ^member_one_id and c.member_two_id == ^member_two_id,
        preload: [:member_one, :member_two]
    )
  end

  @doc """
  Creates a new conversation between two members.
  Returns `{:ok, conversation}` if successful, or `{:error, changeset}` if creation fails.
  """
  defp create_conversation(member_one_id, member_two_id) do
    %Conversation{}
    |> Conversation.changeset(%{member_one_id: member_one_id, member_two_id: member_two_id})
    |> Repo.insert()
  end
end
