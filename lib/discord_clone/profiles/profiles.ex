defmodule DiscordClone.Profiles.Profiles do
  import Ecto.Query, warn: false
  alias DiscordClone.Repo
  alias DiscordClone.Profiles.Profile

  def create_profile(user_id) do
    %Profile{}
    |> Profile.changeset(%{user_id: user_id})
    |> Repo.insert()
  end
end
