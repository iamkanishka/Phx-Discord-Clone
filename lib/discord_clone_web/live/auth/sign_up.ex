defmodule DiscordCloneWeb.Auth.SignUp do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component module={DiscordCloneWeb.CustomComponents.Auth.Auth} id={:signup_auth} />
    """
  end

  @impl true

  def mount(params, session, socket) do
    {:ok, socket}
  end
end
