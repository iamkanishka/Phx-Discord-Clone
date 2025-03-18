defmodule DiscordClone.Messages.Messages do
  import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Messages.Message
  alias DiscordClone.Members.Member
  alias DiscordClone.Profiles.Profile

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
end
