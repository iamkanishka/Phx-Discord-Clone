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

    {:ok, channel} =
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

    # Instead of returning {server, channel}, wrap it properly
    {:ok, server, channel}
  end)
end


  # Creates a new server for the given user and redirects to it if successful.
  # If the user is not authenticated, redirects to the sign-in page.
  # If the server creation fails, returns an error or indicates no server was found.
  def create_and_redirect_to_server(user_id, image_url, name) do
    # Attempt to get the initial profile for the given user
    with {:ok, profile} <- Profiles.initial_profile(user_id),
         # Attempt to create a new server associated with the profile
         {:ok, {:ok, server, channel}} <- create_server(profile.id, image_url, name) do
      case {server, channel} do
        # If the server creation fails and returns nil, indicate no server was found
        {nil, _} ->
          {:ok, :no_server_found}

          # If a server is successfully created, redirect to the server's page with channel id

        {%Server{id: server_id}, %Channel{id: channel_id}} ->
          {:redirect, "/servers/#{server_id}/channel/#{channel_id}"}
      end
    else
      # Handle authentication failure by redirecting to the sign-in page
      {:error, :unauthenticated} -> {:redirect, "/auth/logout"}
      # Handle any other errors (e.g., validation issues) by returning the changeset
      {:error, changeset} -> {:error, changeset}
    end
  end

  def delete_server_and_redirect(server_id, profile_id) do
    with {:ok, _deleted_server} <- delete_server(server_id, profile_id),
         next_server <- get_next_server(profile_id) do
      case next_server do
        nil -> {:redirect, "/auth/logout"}
        %Server{id: new_server_id} -> {:redirect, "/servers/#{new_server_id}"}
      end
    else
      {:error, :unauthenticated} -> {:redirect, "/auth/logout"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp get_next_server(profile_id) do
    Repo.one(
      from s in Server,
        where: s.profile_id == ^profile_id,
        limit: 1,
        order_by: [desc: s.inserted_at]
    )
  end

  @doc """
  Removes a member from a server, ensuring that:
  - The server exists with the given `server_id`.
  - The server does not belong to the given `profile_id`.
  - The member exists in the server.
  """
  def leave_server(server_id, profile_id) do
    IO.inspect(server_id, profile_id)

    Repo.transaction(fn ->
      # Ensure the server exists and does not belong to the given profile
      case Repo.get_by(Server, id: server_id) do
        nil ->
          {:error, :server_not_found}

        server ->
          server = Repo.preload(server, :members)

          if server.profile_id == profile_id do
            {:error, :cannot_remove_owner}
          else
            # Check if the member exists in the server
            case Enum.find(server.members, &(&1.profile_id == profile_id)) do
              nil ->
                {:error, :member_not_found}

              _member ->
                # Remove the member from the server
                from(m in Member,
                  where: m.server_id == ^server_id and m.profile_id == ^profile_id
                )
                |> Repo.delete_all()

                {:ok, :member_removed}
            end
          end
      end
    end)
  end

  @doc """
  Removes a member from a server, ensuring that:
  - The server exists with the given `server_id`.
  - The server does not belong to the given `profile_id`.
  - The member exists in the server.
  """
  def leave_server(server_id, profile_id) do
    Repo.transaction(fn ->
      # Ensure the server exists and does not belong to the given profile
      server =
        Repo.get_by!(Server, id: server_id)
        |> Repo.preload(:members)

      if server.profile_id == profile_id do
        {:error, :cannot_remove_owner}
      else
        # Check if the member exists in the server
        case Enum.find(server.members, &(&1.profile_id == profile_id)) do
          nil ->
            {:error, :member_not_found}

          _member ->
            # Remove the member from the server
            from(m in Member,
              where: m.server_id == ^server_id and m.profile_id == ^profile_id
            )
            |> Repo.delete_all()
        end
      end
    end)
  end

  # Updates the server with the given ID and redirects to it if successful.
  # If the server is not found or unauthorized, returns an error.
  # If the update fails, returns an error with the reason.
  def update_and_redirect_to_server(server_id, profile_id, %{name: name, image_url: image_url}) do
    with {:ok, updated_server} <-
           update_server(server_id, profile_id, %{name: name, image_url: image_url}) do
      case updated_server do
        # If the server creation fails and returns nil, indicate no server was found
        nil -> {:ok, :no_server_found}
        # If a server is successfully created, redirect to the server's page
        %Server{id: server_id} -> {:redirect, "/servers/#{server_id}"}
      end
    else
      # Handle authentication failure by redirecting to the sign-in page
      {:error, :unauthenticated} -> {:redirect, "/auth/logout"}
      # Handle any other errors (e.g., validation issues) by returning the changeset
      {:error, changeset} -> {:error, changeset}
    end
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
      {:error, :unauthenticated} -> {:redirect, "/auth/logout"}
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
      {:error, :unauthenticated} -> {:redirect, "/auth/logout"}
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
      {:error, :unauthenticated} -> {:redirect, "/auth/logout"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Fetches detailed server data including channels, members, and user role.

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the user.

  ## Returns
    - A map containing:
      - `server`: The full server struct.
      - `text_channels`: A list of text channels.
      - `audio_channels`: A list of audio channels.
      - `video_channels`: A list of video channels.
      - `members`: A list of server members excluding the user.
      - `role`: The role of the user in the server.
    - `{:error, :not_found}` if the server does not exist.
  """

  def get_server_data(server_id, profile_id) do
    server =
      Repo.get(Server, server_id)
      |> Repo.preload(
        channels: from(c in Channel, order_by: [asc: c.inserted_at]),
        members:
          from(m in Member,
            order_by: [asc: m.role],
            # Preload the user inside profile
            preload: [profile: [:user]]
          )
      )

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

  @doc """
  Updates a server's name and image URL.

  ## Parameters
    - `server_id`: The ID of the server to update.
    - `profile_id`: The ID of the profile requesting the update (must be the owner).
    - `attrs`: A map containing `:name` and `:image_url` for updating the server.

  ## Returns
    - `{:ok, updated_server}` on success.
    - `{:error, "Server not found or unauthorized"}` if the server is not found or the user lacks permission.
    - `{:error, reason}` if the update fails.
  """
  def update_server(server_id, profile_id, %{name: name, image_url: image_url}) do
    case Repo.get_by(Server, id: server_id, profile_id: profile_id) do
      nil ->
        {:error, "Server not found or unauthorized"}

      server ->
        server
        |> Server.changeset(%{name: name, image_url: image_url})
        |> Repo.update()
        |> case do
          {:ok, updated_server} -> {:ok, updated_server}
          {:error, changeset} -> {:error, "Failed to update server: #{inspect(changeset.errors)}"}
        end
    end
  end

  @doc """
  Generates a new invite code for a server.

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the profile requesting the update (must be the owner).

  ## Returns
    - `{:ok, updated_server}` on success.
    - `{:error, "Server not found or unauthorized"}` if the server is not found or the user lacks permission.
    - `{:error, reason}` if the update fails.
  """
  def update_server_invite_code(server_id, profile_id) do
    case Repo.get_by(Server, id: server_id, profile_id: profile_id) do
      nil ->
        {:error, "Server not found or unauthorized"}

      server ->
        server
        |> Server.changeset(%{invite_code: Ecto.UUID.generate()})
        |> Repo.update()
        |> case do
          {:ok, updated_server} ->
            {:ok, updated_server}

          {:error, changeset} ->
            {:error, "Failed to update server invite code: #{inspect(changeset.errors)}"}
        end
    end
  end

  @doc """
  Deletes a server, but only if the requesting profile is the owner.

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the profile requesting the deletion (must be the owner).

  ## Returns
    - `{:ok, "Server deleted successfully"}` on success.
    - `{:error, "Server not found or unauthorized"}` if the server is not found or the user lacks permission.
    - `{:error, reason}` if the deletion fails.
  """
  def delete_server(server_id, profile_id) do
    case Repo.get_by(Server, id: server_id, profile_id: profile_id) do
      nil ->
        {:error, "Server not found or unauthorized"}

      server ->
        case Repo.delete(server) do
          {:ok, _} -> {:ok, "Server deleted successfully"}
          {:error, reason} -> {:error, "Failed to delete server: #{inspect(reason)}"}
        end
    end
  end

  @doc """
  Removes a member from a server, but prevents the owner from being removed.

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the profile to be removed.

  ## Returns
    - `{:ok, "Member removed successfully"}` if the member is removed.
    - `{:error, "Server not found or you are the owner"}` if the server is not found or the user is the owner.
    - `{:error, "Failed to remove member"}` if the removal fails.
  """
  def remove_member_from_server(server_id, profile_id) do
    server_query =
      from s in Server,
        where: s.id == ^server_id and s.profile_id != ^profile_id,
        join: m in assoc(s, :members),
        where: m.profile_id == ^profile_id,
        select: s

    case Repo.one(server_query) do
      nil ->
        {:error, "Server not found or you are the owner"}

      server ->
        case Repo.delete_all(
               from m in Member,
                 where: m.server_id == ^server.id and m.profile_id == ^profile_id
             ) do
          {count, _} when count > 0 -> {:ok, "Member removed successfully"}
          _ -> {:error, "Failed to remove member"}
        end
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
