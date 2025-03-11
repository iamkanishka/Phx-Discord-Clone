defmodule DiscordClone.Profiles.Profiles do
  import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Profiles.Profile

  def initial_profile(user_id) do
    case Repo.get_by(Profile, user_id: user_id) do
      nil ->
        create_profile(user_id)

      profile ->
        {:ok, profile}
    end
  end

  defp create_profile(user_id) do
    profile_changeset =
      Profile.changeset(%Profile{}, %{
        user_id: user_id
        # name: "#{user.first_name} #{user.last_name}",
        # image_url: user.image_url,
        # email: user.email
      })

    case Repo.insert(profile_changeset) do
      {:ok, profile} -> {:ok, profile}
      {:error, changeset} -> {:error, changeset}
    end
  end



  # def create_profile(user_id) do
  #   %Profile{}
  #   |> Profile.changeset(%{user_id: user_id})
  #   |> Repo.insert()
  # end
end
