defmodule DiscordClone.Invites.Invites do
import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Servers.Server
  alias DiscordClone.Members.Member

  @doc """
  Joins a user to a server using an invite code.

  If the user is already a member of the server, they are redirected.
  Otherwise, they are added as a new member and redirected to the server.
  """
  def join_server_by_invite(invite_code, profile_id) do
    # Check if the server exists and the user is already a member
    existing_server =
      Repo.one(
        from s in Server,
        where: s.invite_code == ^invite_code,
        join: m in Member, on: m.server_id == s.id,
        where: m.profile_id == ^profile_id,
        select: s
      )

    # If the user is already a member, return the server ID (equivalent to redirect)
    if existing_server do
      {:ok, existing_server.id}
    else
      # Attempt to add the user as a new member
      case Repo.get_by(Server, invite_code: invite_code) do
        nil ->
          {:error, :server_not_found}

        server ->
          new_member = %Member{
            server_id: server.id,
            profile_id: profile_id
          }

          case Repo.insert(new_member) do
            {:ok, _member} ->
              {:ok, server.id}

            {:error, changeset} ->
              {:error, changeset}
          end
      end
    end
  end
end
