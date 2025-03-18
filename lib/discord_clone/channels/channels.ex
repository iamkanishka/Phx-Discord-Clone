defmodule DiscordClone.Channels.Channels do
  import Ecto.Query, warn: false

  import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Servers.Server

  alias DiscordClone.Channels.Channel

  @doc """
  Updates a channel in a server if the requesting user has the necessary role (ADMIN or MODERATOR).

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the user making the update.
    - `channel_id`: The ID of the channel to update.
    - `attrs`: A map containing the new `name` and `type` for the channel.

  ## Returns
    - `{:ok, updated_server}` if the update is successful.
    - `{:error, reason}` if the update fails.
  """
  def update_channel(server_id, profile_id, channel_id, %{name: name, type: type}) do
    # Ensure user is an ADMIN or MODERATOR in the server
    server_query =
      from s in Server,
        where: s.id == ^server_id,
        join: m in assoc(s, :members),
        where:
          m.profile_id == ^profile_id and
            m.role in ["ADMIN", "MODERATOR"],
        select: s

    case Repo.one(server_query) do
      nil ->
        {:error, "Unauthorized or server not found"}

      _server ->
        # Update the channel, ensuring it's not named "general"
        from(c in Channel,
          where: c.id == ^channel_id and c.server_id == ^server_id and c.name != "general"
        )
        |> Repo.update_all(set: [name: name, type: type])

        {:ok, "Channel updated successfully"}
    end
  end


   @doc """
  Creates a new channel in a server if the requesting user has the necessary role (ADMIN or MODERATOR).

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the user creating the channel.
    - `attrs`: A map containing the `name` and `type` for the new channel.

  ## Returns
    - `{:ok, new_channel}` if the creation is successful.
    - `{:error, reason}` if the creation fails.
  """
  def create_channel(server_id, profile_id, %{name: name, type: type}) do
    # Ensure user is an ADMIN or MODERATOR in the server
    server_query =
      from s in Server,
        where: s.id == ^server_id,
        join: m in assoc(s, :members),
        where:
          m.profile_id == ^profile_id and
            m.role in ["ADMIN", "MODERATOR"],
        select: s

    case Repo.one(server_query) do
      nil ->
        {:error, "Unauthorized or server not found"}

      _server ->
        # Insert new channel
        %Channel{}
        |> Channel.changeset(%{
          profile_id: profile_id,
          server_id: server_id,
          name: name,
          type: type
        })
        |> Repo.insert()
    end
  end

end
