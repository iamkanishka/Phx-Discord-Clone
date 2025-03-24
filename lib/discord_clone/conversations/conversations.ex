defmodule DiscordClone.Conversations.Conversations do
  import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Conversations.Conversation
  alias DiscordClone.DirectMessages.DirectMessage

  @doc """
  Sends a direct message in a conversation, ensuring the user is a participant.

  ## Params:
    - `conversation_id` (Binary ID): The ID of the conversation.
    - `profile_id` (Binary ID): The ID of the user's profile.
    - `content` (String): The message content.
    - `file_url` (String | nil): The URL of an attached file (if any).

  ## Returns:
    - `{:ok, message}` on success.
    - `{:error, reason}` if the conversation or member is not found.
  """
  def send_message(conversation_id, profile_id, content, file_url \\ nil) do
    with {:ok, conversation} <- get_conversation(conversation_id, profile_id),
         {:ok, member} <- get_member(conversation, profile_id),
         {:ok, message} <- create_message(conversation_id, member.id, content, file_url) do
      {:ok, message}
    else
      {:error, _} = error -> error
    end
  end


    # Fetches the conversation if the profile belongs to it.
    defp get_conversation(conversation_id, profile_id) do
      query =
        from c in Conversation,
          where: c.id == ^conversation_id and
                 (c.member_one_id in ^[profile_id] or c.member_two_id in ^[profile_id]),
          preload: [
            member_one: [:profile],
            member_two: [:profile]
          ]

      case Repo.one(query) do
        nil -> {:error, "Conversation not found"}
        conversation -> {:ok, conversation}
      end
    end


     # Determines which member the profile belongs to in the conversation.
  defp get_member(%Conversation{member_one: %{profile_id: pid}} = conv, pid) do
    {:ok, conv.member_one}
  end



end
