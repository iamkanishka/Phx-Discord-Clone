defmodule DiscordClone.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DiscordClone.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> DiscordClone.Accounts.create_user()

    user
  end
end
