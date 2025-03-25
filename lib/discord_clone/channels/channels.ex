defmodule DiscordClone.Channels.Channels do
  import Ecto.Query, warn: false

  import Ecto.Query, warn: false
  alias DiscordClone.Profiles.Profiles
  alias DiscordClone.Repo
  alias DiscordClone.Servers.Server

  alias DiscordClone.Channels.Channel

  @doc """
  Fetches a channel by its ID.
  """
  def get_channel_by_id(channel_id) do
    case Repo.get(Channel, channel_id) do
      nil -> {:error, "Channel not found"}
      channel -> {:ok, channel}
    end
  end

  # Creates a new channel for the given user and redirects to it if successful.
  # If the user is not authenticated, redirects to the sign-in page.
  # If the server creation fails, returns an error or indicates no server was found.
  def create_channel_and_redirect_to_server(server_id, user_id, name, type) do
    # Attempt to get the initial profile for the given user
    with {:ok, profile} <- Profiles.initial_profile(user_id),
         # Attempt to create a new Channel  associated with the profile
         {:ok, channel} <- create_channel(server_id, profile.id, %{name: name, type: type}) do
      case channel do
        # If the Channel creation fails and returns nil, indicate no server was found
        {nil, _} ->
          {:ok, :no_server_found}

        # If a Channel is successfully created, redirect to the server's page with channel id

        {%Server{id: server_id}, %Channel{id: channel_id}} ->
          {:redirect, "/servers/#{server_id}/channel/#{channel_id}"}
      end
    else
      # Handle authentication failure by redirecting to the sign-in page
      {:error, :unauthenticated} -> {:redirect, "/auth/sign_in"}
      # Handle any other errors (e.g., validation issues) by returning the changeset
      {:error, changeset} -> {:error, changeset}
    end
  end

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
            m.role in [:ADMIN, :MODERATOR],
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
