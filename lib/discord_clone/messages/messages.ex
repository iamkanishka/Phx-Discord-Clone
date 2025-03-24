defmodule DiscordClone.Messages.Messages do
  import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Messages.Message


  # Adjust batch size as needed
  @messages_batch 20

  @doc """
  Fetches a batch of messages for a given channel.

  If a cursor (message ID) is provided, it fetches the next batch after that message.
  Otherwise, it fetches the latest messages.
  """
  def get_messages(channel_id, cursor \\ nil) do
    base_query =
      from m in Message,
        where: m.channel_id == ^channel_id,
        join: mem in assoc(m, :member),
        join: p in assoc(mem, :profile),
        preload: [member: {mem, profile: p}],
        order_by: [desc: m.inserted_at]

    # Apply cursor-based pagination if a cursor is provided
    query =
      if cursor do
        from m in base_query,
          # Fetch messages older than the cursor
          where: m.id < ^cursor,
          limit: @messages_batch
      else
        from m in base_query,
          limit: @messages_batch
      end

    messages = Repo.all(query)

    # Determine the next cursor
    next_cursor =
      case Enum.at(messages, @messages_batch - 1) do
        nil -> nil
        last_message -> last_message.id
      end

    %{messages: messages, next_cursor: next_cursor}
  end


  @doc """
Handles message modification (delete or update) based on the request type.

- Checks authorization (message owner, admin, or moderator).
- Supports DELETE (soft delete) and PATCH (content update).
- Ensures the server, channel, and message exist before performing any action.
"""
def modify_message(profile_id, message_id, server_id, channel_id, action, new_content \\ nil) do
  with {:ok, server} <- find_server(profile_id, server_id),
       {:ok, channel} <- find_channel(channel_id, server_id),
       {:ok, member} <- find_member(server, profile_id),
       {:ok, message} <- find_message(message_id, channel_id),
       :ok <- authorize_action(member, message, action) do
    case action do
      :delete -> delete_message(message)
      :update -> update_message(message, new_content)
    end
  end
end

  @doc """
  Finds a server where the user is a member.
  """
  defp find_server(profile_id, server_id) do
    case Repo.one(
           from s in Server,
             where: s.id == ^server_id,
             join: m in assoc(s, :members),
             where: m.profile_id == ^profile_id,
             preload: [:members]
         ) do
      nil -> {:error, "Server not found"}
      server -> {:ok, server}
    end
  end


  @doc """
  Finds a channel within the specified server.
  """
  defp find_channel(channel_id, server_id) do
    case Repo.one(
           from c in Channel,
             where: c.id == ^channel_id and c.server_id == ^server_id
         ) do
      nil -> {:error, "Channel not found"}
      channel -> {:ok, channel}
    end
  end

    @doc """
  Finds a member in the server.
  """
  defp find_member(server, profile_id) do
    case Enum.find(server.members, &(&1.profile_id == profile_id)) do
      nil -> {:error, "Member not found"}
      member -> {:ok, member}
    end
  end

    @doc """
  Finds a message in the specified channel.
  """
  defp find_message(message_id, channel_id) do
    case Repo.one(
           from m in Message,
             where: m.id == ^message_id and m.channel_id == ^channel_id,
             preload: [:member]
         ) do
      nil -> {:error, "Message not found"}
      message when message.deleted -> {:error, "Message already deleted"}
      message -> {:ok, message}
    end
  end

    @doc """
  Checks if the member has permission to modify the message.
  """
  defp authorize_action(member, message, action) do
    is_owner = message.member_id == member.id
    is_admin = member.role == :admin
    is_moderator = member.role == :moderator
    can_modify = is_owner or is_admin or is_moderator

    if can_modify do
      :ok
    else
      {:error, "Unauthorized"}
    end
  end


    @doc """
  Soft deletes a message by setting `deleted` to true and updating content.
  """
  defp delete_message(message) do
    message
    |> Message.changeset(%{file_url: nil, content: "This message has been deleted.", deleted: true})
    |> Repo.update()
  end

    @doc """
  Updates the content of a message.
  """
  defp update_message(message, new_content) do
    message
    |> Message.changeset(%{content: new_content})
    |> Repo.update()
  end




    @doc """
  Creates a new message in a given channel.

  - Ensures the profile exists and is a member of the server.
  - Validates the presence of required parameters.
  - Associates the message with the correct member and channel.
  - Returns the newly created message with preloaded member profile.
  """
  def create_message(profile_id, server_id, channel_id, content, file_url \\ nil) do
    with {:ok, server} <- find_server(profile_id, server_id),
         {:ok, channel} <- find_channel(channel_id, server_id),
         {:ok, member} <- find_member(server, profile_id),
         :ok <- validate_content(content) do
      insert_message(channel_id, member.id, content, file_url)
    end
  end

    @doc """
  Finds a server where the user is a member.
  """
  defp find_server(profile_id, server_id) do
    case Repo.one(
           from s in Server,
             where: s.id == ^server_id,
             join: m in assoc(s, :members),
             where: m.profile_id == ^profile_id,
             preload: [:members]
         ) do
      nil -> {:error, "Server not found"}
      server -> {:ok, server}
    end
  end

    @doc """
  Finds a channel within the specified server.
  """
  defp find_channel(channel_id, server_id) do
    case Repo.one(
           from c in Channel,
             where: c.id == ^channel_id and c.server_id == ^server_id
         ) do
      nil -> {:error, "Channel not found"}
      channel -> {:ok, channel}
    end
  end


    @doc """
  Finds a member in the server.
  """
  defp find_member(server, profile_id) do
    case Enum.find(server.members, &(&1.profile_id == profile_id)) do
      nil -> {:error, "Member not found"}
      member -> {:ok, member}
    end
  end

    @doc """
  Validates that the content is present.
  """
  defp validate_content(nil), do: {:error, "Content missing"}
  defp validate_content(""), do: {:error, "Content missing"}
  defp validate_content(_), do: :ok




end
