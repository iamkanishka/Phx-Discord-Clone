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

end
