defmodule DiscordCloneWeb.AuthController do
  alias DiscordClone.Users.Users
  alias Ueberauth.Auth
  use DiscordCloneWeb, :controller



  # Ueberauth plug handles OAuth authentication flows
  plug Ueberauth

  @doc """
  Initiates the authentication request.
  Ueberauth automatically redirects the user to the provider's login page.
  """
  def request(_conn, _params) do
    # No explicit handling required as Ueberauth manages the redirection.
  end

  @doc """
  Handles the OAuth callback after successful authentication.
  - Retrieves user information from the authentication provider.
  - Finds or creates a user in the database.
  - Stores user information in the session.
  - Redirects the user to the initial setup page.
  """
  def callback(%{assigns: %{ueberauth_auth: %Auth{} = auth}} = conn, _params) do
    case Users.find_or_create_user(auth) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user) # Store user in session
        |> put_flash(:info, "Welcome back, #{user.name}!") # Display success message
        # |> redirect(to: "/initial-setup/#{user.id}") # Redirect to user setup page
        |> redirect(to: "/initial-setup") # Redirect to user setup page


      {:error, reason} ->
        conn
        |> put_flash(:error, "Authentication failed: #{reason}") # Show error message
        |> redirect(to: "/auth/sign-in") # Redirect to sign-in page
    end
  end

  @doc """
  Handles authentication failure.
  - Extracts error messages from Ueberauth.
  - Displays an error flash message.
  - Redirects the user to the home page.
  """
  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    # Log the failure for debugging purposes
    IO.inspect(failure, label: "OAuth Failure")

    # Convert error messages into a readable string
    errors =
      Enum.map(failure.errors, fn error ->
        "#{error.message_key}: #{error.message}"
      end)
      |> Enum.join(", ")

    conn
    |> put_flash(:error, "Authentication failed: #{errors}") # Show error message
    |> redirect(to: "/") # Redirect to home page
  end

  @doc """
  Logs out the user.
  - Clears the session to remove user data.
  - Displays a logout confirmation message.
  - Redirects the user to the homepage.
  """
  def logout(conn, _params) do
     conn
     |> delete_resp_cookie("_discord_clone_key")
    |> configure_session(drop: true) # Clears the session
    |> delete_session(:current_user)
    |> put_flash(:info, "You have been logged out.") # Show logout message
    |> redirect(to: "/auth/sign-in") # Redirect to home page
  end
end
