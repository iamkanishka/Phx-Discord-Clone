defmodule DiscordCloneWeb.AuthController do
  alias DiscordClone.Accounts.Accounts
  alias Ueberauth.Auth
  use DiscordCloneWeb, :controller

  plug Ueberauth

  def request(_conn, _params) do
    # Ueberauth automatically handles this redirection
  end

  def callback(%{assigns: %{ueberauth_auth: %Auth{} = auth}} = conn, _params) do
    case Accounts.find_or_create_user(auth) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: "/initial-setup/#{user.id}")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Authentication failed: #{reason}")
        |> redirect(to: "/auth/sign-in")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    # Log the failure for debugging
    IO.inspect(failure, label: "OAuth Failure")

    # Extract human-readable error messages
    errors =
      Enum.map(failure.errors, fn error ->
        "#{error.message_key}: #{error.message}"
      end)
      |> Enum.join(", ")

    conn
    |> put_flash(:error, "Authentication failed: #{errors}")
    |> redirect(to: "/")
  end
end
