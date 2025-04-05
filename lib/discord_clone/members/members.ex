defmodule DiscordClone.Members.Members do
  import Ecto.Query, warn: false

  alias DiscordClone.Profiles.Profiles
  alias DiscordClone.Repo
  alias DiscordClone.Members.Member

  def get_member_by_server_and_user(server_id, user_id) do
    with {:ok, profile} <- Profiles.initial_profile(user_id),
         {:ok, member} <- get_member_by_server_and_profile(server_id, profile.id) do
      {:ok, member, profile.id}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Finds the first member in a server based on the given server ID and profile ID.
  """
  def get_member_by_server_and_profile(server_id, profile_id) do
    case Repo.one(
           from m in Member,
             where: m.server_id == ^server_id and m.profile_id == ^profile_id
         ) do
      nil -> {:error, "Member not found"}
      member -> {:ok, member}
    end
  end

  @doc """
  Removes a member from a server if the requesting user is the owner.

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the server owner making the request.
    - `member_id`: The ID of the member to be removed.

  ## Returns
    - `{:ok, updated_server_members}` if the member is successfully removed.
    - `{:error, reason}` if the operation fails.
  """
  def remove_member(server_id, profile_id, member_id) do
    # Ensure the requester is the server owner
    server_query =
      from s in Server,
        where: s.id == ^server_id and s.profile_id == ^profile_id,
        select: s

    case Repo.one(server_query) do
      nil ->
        {:error, "Unauthorized or server not found"}

      _server ->
        # Delete the specified member, ensuring they are not the owner
        delete_query =
          from m in Member,
            where:
              m.id == ^member_id and m.profile_id != ^profile_id and m.server_id == ^server_id

        {count, _} = Repo.delete_all(delete_query)

        if count > 0 do
          # Fetch the updated members list after deletion
          updated_members =
            Repo.all(
              from m in Member,
                where: m.server_id == ^server_id,
                order_by: [asc: m.role],
                preload: [:profile]
            )

          {:ok, updated_members}
        else
          {:error, "Member not found or cannot be removed"}
        end
    end
  end

  @doc """
  Updates a member's role in a server if the requesting user is the owner.

  ## Parameters
    - `server_id`: The ID of the server.
    - `profile_id`: The ID of the server owner making the request.
    - `member_id`: The ID of the member whose role is being updated.
    - `role`: The new role to assign.

  ## Returns
    - `{:ok, updated_server_members}` if the role is successfully updated.
    - `{:error, reason}` if the operation fails.
  """
  def update_member_role(server_id, profile_id, member_id, role) do
    # Ensure the requester is the server owner
    server_query =
      from s in Server,
        where: s.id == ^server_id and s.profile_id == ^profile_id,
        select: s

    case Repo.one(server_query) do
      nil ->
        {:error, "Unauthorized or server not found"}

      _server ->
        # Update the specified member's role, ensuring they are not the owner
        update_query =
          from m in Member,
            where:
              m.id == ^member_id and m.profile_id != ^profile_id and m.server_id == ^server_id

        case Repo.update_all(update_query, set: [role: role]) do
          {count, _} when count > 0 ->
            # Fetch the updated members list after role update
            updated_members =
              Repo.all(
                from m in Member,
                  where: m.server_id == ^server_id,
                  order_by: [asc: m.role],
                  preload: [:profile]
              )

            {:ok, updated_members}

          _ ->
            {:error, "Member not found or cannot be updated"}
        end
    end
  end
end
