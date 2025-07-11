defmodule DiscordClone.DirectMessages.DirectMessages do
  import Ecto.Query, warn: false
  alias DiscordClone.Profiles.Profiles
  alias DiscordClone.DirectMessages.MessageLog
  alias DiscordClone.Repo
  alias DiscordClone.Conversations.Conversation
  alias DiscordClone.DirectMessages.DirectMessage
  alias DiscordClone.Members.Member

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
        join: u in assoc(p, :user),

        # preload: [member: {m, profile: p}],
        preload: [member: {m, profile: {p, user: u}}],
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

    %{messages: messages, next_cursor: next_cursor}
  end

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
  def send_message(conversation_id, user_id, content, file \\ nil) do
    with {:ok, profile} <- Profiles.initial_profile(user_id),
         {:ok, conversation} <- get_conversation(conversation_id, profile.id),
         {:ok, member} <- get_member(conversation, profile.id),
         {:ok, message} <- create_message(conversation_id, member.id, content, file) do
      {:ok, message}
    else
      {:error, _} = error -> error
    end
  end

  # Creates the message in the database.
  defp create_message(conversation_id, member_id, content, file) do
    try do
      %DirectMessage{}
      |> DirectMessage.changeset(%{
        content: content,
        file_url: file.file_URL,
        file_type: file.file_type,
        conversation_id: conversation_id,
        member_id: member_id
      })
      |> Repo.insert()
      |> case do
        {:ok, direct_message} ->
          IO.inspect(direct_message, label: "Direct Message")
          message = Repo.preload(direct_message, member: [profile: :user])

          Phoenix.PubSub.broadcast(
            DiscordClone.PubSub,
            "conversation:#{conversation_id}",
            {:new_conversation, message}
          )

          {:ok, message}

        {:error, changeset} ->
          # {:error, "Failed to create message: #{format_errors(changeset)}"}
          {:error, "Failed to create message: #{IO.inspect(changeset)}"}
      end
    catch
      error ->
        {:error, error}
    end
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
  # defp get_conversation(conversation_id, profile_id) do

  #   query =
  #     from c in Conversation,
  #       where:
  #         c.id == ^conversation_id and  (c.member_one_id == ^profile_id or c.member_two_id == ^profile_id),
  #       preload: [:member_one, :member_two]

  #   case Repo.one(query) do
  #     nil -> {:error, "Conversation not found"}
  #     conversation -> {:ok, conversation}
  #   end
  # end

  # Fetch a conversation by ID and ensure the given profile is a participant
  # defp get_conversation(conversation_id, profile_id) do
  #   query =
  #     from c in Conversation,
  #       # Look up the conversation by its ID
  #       where: c.id == ^conversation_id,
  #       # Preload the associated member_one and member_two profiles
  #       preload: [:member_one, :member_two]

  #   case Repo.one(query) do
  #     # Return error if no conversation with the given ID exists
  #     nil ->
  #       {:error, "Conversation not found"}

  #     # If the profile is member_one, return the conversation
  #     %Conversation{member_one: %{id: ^profile_id}} = conversation ->
  #        IO.inspect(conversation, label: "Member One")
  #       {:ok, conversation}

  #     # If the profile is member_two, return the conversation
  #     %Conversation{member_two: %{id: ^profile_id}} = conversation ->
  #       IO.inspect(conversation, label: "Member Two")

  #       {:ok, conversation}

  #     # If the profile is not a participant, return an error
  #     _ ->
  #       {:error, "Profile is not a participant in the conversation"}
  #   end
  # end

  defp get_conversation(conversation_id, profile_id) do
    query =
      from c in Conversation,
        where: c.id == ^conversation_id,
        preload: [:member_one, :member_two]

    case Repo.one(query) do
      nil ->
        {:error, "Conversation not found"}

      %Conversation{member_one: m1, member_two: m2} = conversation ->
        if m1.profile_id == profile_id or m2.profile_id == profile_id do
          {:ok, conversation}
        else
          {:error, "You are not a participant in this conversation"}
        end
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
