defmodule DiscordClone.DirectMessages.DirectMessages do
  import Ecto.Query
  alias DiscordClone.Repo
  alias DiscordClone.DirectMessages.DirectMessage

  # Define the batch size
  @messages_batch 20

  @doc """
  Fetches a batch of direct messages for a given conversation.

  If a `cursor` is provided, it fetches messages after that cursor (pagination).
  Otherwise, it fetches the latest messages.

  ## Parameters:
  - `conversation_id` (binary): The ID of the conversation.
  - `cursor` (binary, optional): The ID of the last message retrieved (for pagination).

  ## Returns:
  - A tuple `{messages, next_cursor}`, where:
    - `messages`: A list of messages.
    - `next_cursor`: The ID of the last message in the batch (for pagination).
  """
  def fetch_messages(conversation_id, cursor \\ nil) do
    base_query =
      from dm in DirectMessage,
        where: dm.conversation_id == ^conversation_id,
        join: m in assoc(dm, :member),
        join: p in assoc(m, :profile),
        preload: [member: {m, profile: p}],
        order_by: [desc: dm.inserted_at],
        limit: @messages_batch

    # Apply cursor-based pagination if a cursor is provided
    query =
      if cursor do
        from dm in base_query,
          # Assumes ID ordering matches `inserted_at`
          where: dm.id < ^cursor
      else
        base_query
      end

    messages = Repo.all(query)

    # Determine the next cursor for pagination
    next_cursor =
      if length(messages) == @messages_batch do
        List.last(messages).id
      else
        nil
      end

    {messages, next_cursor}
  end

  @doc """
  Modifies a message (delete, restore, or update) in a conversation.

  ## Params:
    - `profile_id` (Binary ID): The profile ID of the requesting user.
    - `conversation_id` (Binary ID): The ID of the conversation.
    - `message_id` (Binary ID): The ID of the direct message.
    - `method` (`:delete` | `:patch` | `:restore`): The action to perform.
    - `new_content` (String | nil): The updated content (only for `:patch`).

  ## Returns:
    - `{:ok, updated_message}` on success.
    - `{:error, reason}` on failure.
  """
  def modify_message(profile_id, conversation_id, message_id, method, new_content \\ nil) do
    with {:ok, conversation} <- get_conversation(conversation_id, profile_id),
         {:ok, member} <- get_member(conversation, profile_id),
         {:ok, message} <- get_message(message_id, conversation_id, method),
         {:ok, _} <- check_permissions(member, message, method),
         {:ok, updated_message} <- process_message(method, message, new_content) do
      {:ok, updated_message}
    else
      {:error, _} = error -> error
    end
  end

  # Fetch conversation ensuring the profile is a participant
  defp get_conversation(conversation_id, profile_id) do
    query =
      from c in Conversation,
        where:
          c.id == ^conversation_id and
            (c.member_one_id == ^profile_id or c.member_two_id == ^profile_id),
        preload: [:member_one, :member_two]

    case Repo.one(query) do
      nil -> {:error, "Conversation not found"}
      conversation -> {:ok, conversation}
    end
  end

  # Determines which member the profile belongs to in the conversation
  defp get_member(%Conversation{member_one: %{profile_id: pid}} = conv, pid),
    do: {:ok, conv.member_one}

  defp get_member(%Conversation{member_two: %{profile_id: pid}} = conv, pid),
    do: {:ok, conv.member_two}

  defp get_member(_, _), do: {:error, "Member not found"}

  # Fetch message with or without deleted ones (for restore functionality)
  defp get_message(message_id, conversation_id, method) do
    query =
      from m in DirectMessage,
        where: m.id == ^message_id and m.conversation_id == ^conversation_id,
        preload: [:member]

    case Repo.one(query) do
      nil ->
        {:error, "Message not found"}

      %DirectMessage{deleted: true} = msg when method != :restore ->
        {:error, "Message has been deleted"}

      message ->
        {:ok, message}
    end
  end

  # Checks if the user has permission to modify the message
  defp check_permissions(
         %Member{id: member_id, role: role},
         %DirectMessage{member_id: message_owner_id},
         method
       ) do
    is_owner = member_id == message_owner_id
    is_admin_or_moderator = role in [:ADMIN, :MODERATOR]
    can_modify = is_owner or is_admin_or_moderator

    case {method, can_modify, is_owner} do
      # Only owners can edit
      {:patch, true, true} -> {:ok, :allowed}
      # Admins, moderators, and owners can delete
      {:delete, true, _} -> {:ok, :allowed}
      # Admins and moderators can restore
      {:restore, true, _} -> {:ok, :allowed}
      _ -> {:error, "Unauthorized"}
    end
  end

  # Handles message updates, deletions, and restorations
  defp process_message(:delete, message, _new_content) do
    log_change(message, "deleted")

    message
    |> Ecto.Changeset.change(%{
      file_url: nil,
      content: "This message has been deleted.",
      deleted: true
    })
    |> Repo.update()
  end

  defp process_message(:patch, message, new_content) when is_binary(new_content) do
    log_change(message, "edited")

    message
    |> Ecto.Changeset.change(%{content: new_content})
    |> Repo.update()
  end

  defp process_message(:restore, message, _new_content) do
    log_change(message, "restored")

    message
    |> Ecto.Changeset.change(%{deleted: false})
    |> Repo.update()
  end

  defp process_message(_, _, _), do: {:error, "Invalid request"}

    # Logs message modifications for auditing purposes
    defp log_change(%DirectMessage{id: message_id, content: content, member_id: member_id}, action) do
      Repo.insert(%MessageLog{
        message_id: message_id,
        member_id: member_id,
        action: action,
        old_content: content
      })
    end

    # Usage Example
    # case DiscordClone.DirectMessages.modify_message(user_profile_id, convo_id, msg_id, :delete) do
    #   {:ok, message} -> IO.inspect(message, label: "Message Deleted")
    #   {:error, reason} -> IO.puts("Error: #{reason}")
    # end

    # case DiscordClone.DirectMessages.modify_message(user_profile_id, convo_id, msg_id, :patch, "Edited text") do
    #   {:ok, message} -> IO.inspect(message, label: "Message Updated")
    #   {:error, reason} -> IO.puts("Error: #{reason}")
    # end

end
