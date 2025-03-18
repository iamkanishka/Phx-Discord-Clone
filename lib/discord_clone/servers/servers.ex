defmodule DiscordClone.Servers.Servers do
  import Ecto.Query, warn: false
  alias DiscordClone.Profiles.Profiles
  alias DiscordClone.Repo
  alias DiscordClone.Servers.Server
  alias DiscordClone.Channels.Channel
  alias DiscordClone.Members.Member



   @doc """
  Creates a new server with a default "general" channel and assigns the creator as an admin.

  ## Parameters
    - `profile_id`: The ID of the user creating the server.
    - `image_url`: The URL of the server's image.
    - `name`: The name of the server.

  ## Returns
    - `{:ok, server}` on successful creation.
    - If any operation fails, the transaction is rolled back.
  """

  def create_server(profile_id, image_url, name) do
    Repo.transaction(fn ->
      {:ok, server} =
        %Server{}
        |> Server.changeset(%{
          profile_id: profile_id,
          name: name,
          image_url: image_url,
          invite_code: Ecto.UUID.generate()
        })
        |> Repo.insert()

      {:ok, _channel} =
        %Channel{}
        |> Channel.changeset(%{
          name: "general",
          server_id: server.id,
          profile_id: profile_id
        })
        |> Repo.insert()

      {:ok, _member} =
        %Member{}
        |> Member.changeset(%{
          server_id: server.id,
          profile_id: profile_id,
          role: "ADMIN"
        })
        |> Repo.insert()

      server
    end)
  end


    @doc """
  Finds the first server the user is a member of and redirects to it.

  ## Parameters
    - `user_id`: The ID of the user.

  ## Returns
    - `{:redirect, "/servers/:server_id"}` if a server is found.
    - `{:ok, :no_server_found}` if the user is not in any server.
    - `{:redirect, "/auth/sign_in"}` if authentication fails.
  """

  def find_and_redirect_to_server(user_id) do
    with {:ok, profile} <- Profiles.initial_profile(user_id),
         server <- get_server_by_profile(profile.id) do
      case server do
        nil -> {:ok, :no_server_found}
        %Server{id: server_id} -> {:redirect, "/servers/#{server_id}"}
      end
    else
      {:error, :unauthenticated} -> {:redirect, "/auth/sign_in"}
      {:error, changeset} -> {:error, changeset}
    end
  end


    @doc """
  Fetches the first server the user is a member of.

  ## Parameters
    - `profile_id`: The ID of the profile.

  ## Returns
    - The first `Server` found or `nil` if none exist.
  """

  defp get_server_by_profile(profile_id) do
    Repo.one(
      from s in Server,
        join: m in assoc(s, :members),
        where: m.profile_id == ^profile_id,
        limit: 1
    )
  end

   @doc """
  Retrieves all servers a user is a member of.

  ## Parameters
    - `user_id`: The ID of the user.

  ## Returns
    - `{:ok, servers}` if servers are found.
    - `{:ok, :no_server_found}` if no servers exist for the user.
    - `{:redirect, "/auth/sign_in"}` if authentication fails.
  """

  def find_servers(user_id) do
    with {:ok, profile} <- Profiles.initial_profile(user_id),
         servers <- get_servers_by_profile(profile.id) do
      if Enum.empty?(servers) do
        {:ok, :no_server_found}
      else
        {:ok, servers}
      end
    else
      {:error, :unauthenticated} -> {:redirect, "/auth/sign_in"}
      {:error, changeset} -> {:error, changeset}
    end
  end

    @doc """
  Fetches all servers a user is a member of.

  ## Parameters
    - `profile_id`: The ID of the profile.

  ## Returns
    - A list of `Server` structs.
  """
  defp get_servers_by_profile(profile_id) do
    Repo.all(
      from s in Server,
        join: m in assoc(s, :members),
        where: m.profile_id == ^profile_id
    )
  end


    @doc """
  Retrieves sidebar data for a specific server.

  ## Parameters
    - `server_id`: The ID of the server.
    - `user_id`: The ID of the user.

  ## Returns
    - `{:ok, server_data}` if the server data is found.
    - `{:redirect, "/auth/sign_in"}` if authentication fails.
    - `{:error, changeset}` if an error occurs.
  """

  def find_and_redirect_to_server_sidebar_data(server_id, user_id) do
    with {:ok, profile} <- Profiles.initial_profile(user_id),
         server_data <- get_server_data(server_id, profile.id) do
      {:ok, server_data}
      # case server_data do
      #   nil -> {:ok, :no_server_found}
      #   # if Enum.empty?(server_data) do
      #   #   {:ok, :no_server_found}
      #   # else

      #   # end
      # end
    else
      {:error, :unauthenticated} -> {:redirect, "/auth/sign_in"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def get_server_data(server_id, profile_id) do
    server =
      Repo.get(Server, server_id)
      |> Repo.preload([
        channels: from(c in Channel, order_by: [asc: c.inserted_at]),
        members:
          from(m in Member,
            order_by: [asc: m.role],
            preload: [:profile]
          )
      ])

    if server do
      text_channels = Enum.filter(server.channels, &(&1.type == :TEXT))
      audio_channels = Enum.filter(server.channels, &(&1.type == :AUDIO))
      video_channels = Enum.filter(server.channels, &(&1.type == :VIDEO))

      members = Enum.filter(server.members, &(&1.profile_id != profile_id))

      role =
        server.members
        |> Enum.find(&(&1.profile_id == profile_id))
        |> case do
          nil -> nil
          member -> member.role
        end

      %{
        server: server,
        text_channels: text_channels,
        audio_channels: audio_channels,
        video_channels: video_channels,
        members: members,
        role: role
      }
    else
      {:error, :not_found}
    end
  end

  # def get_server_data(server_id, profile_id) do
  #   query =
  #     from s in Server,
  #       where: s.id == ^server_id,
  #       preload: [
  #         :profile,
  #         members:
  #           ^from(m in Member,
  #             where: m.profile_id != ^profile_id,
  #             order_by: [asc: m.role],
  #             preload: [:profile]
  #           ),
  #         channels:
  #           ^from(c in Channel,
  #             where: c.type in [:TEXT, :AUDIO, :VIDEO],
  #             order_by: [asc: c.inserted_at]
  #           )
  #       ]

  #   case Repo.one(query) do
  #     nil ->
  #       {:error, :not_found}

  #     server ->
  #       # Extract role in a single query
  #       role_query =
  #         from m in Member,
  #           where: m.server_id == ^server_id and m.profile_id == ^profile_id,
  #           select: m.role

  #       role = Repo.one(role_query)

  #       # Group channels by type using Enum.group_by
  #       channel_groups = Enum.group_by(server.channels, & &1.type)

  #       %{
  #         server: server
  #         # text_channels: Map.get(channel_groups, :TEXT, []),
  #         # audio_channels: Map.get(channel_groups, :AUDIO, []),
  #         # video_channels: Map.get(channel_groups, :VIDEO, []),

  #         # members: server.members,
  #         # role: role
  #       }
  #   end
  # end
end
