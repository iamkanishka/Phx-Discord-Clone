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



  # def create_profile(user_id) do
  #   %Profile{}
  #   |> Profile.changeset(%{user_id: user_id})
  #   |> Repo.insert()
  # end
end
