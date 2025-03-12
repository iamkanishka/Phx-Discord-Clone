defmodule DiscordClone.Servers.Servers do
  import Ecto.Query, warn: false
  alias DiscordClone.Profiles.Profiles
  alias DiscordClone.Repo
  alias DiscordClone.Servers.Server
  alias DiscordClone.Channels.Channel
  alias DiscordClone.Members.Member

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

  defp get_server_by_profile(profile_id) do
    Repo.one(
      from s in Server,
        join: m in assoc(s, :members),
        where: m.profile_id == ^profile_id,
        limit: 1
    )
  end

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
  defp get_servers_by_profile(profile_id) do
    Repo.all(
      from s in Server,
        join: m in assoc(s, :members),
        where: m.profile_id == ^profile_id
    )
  end

end
