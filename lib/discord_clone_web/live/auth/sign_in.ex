defmodule DiscordCloneWeb.Auth.SignIn do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component module={DiscordCloneWeb.CustomComponents.Auth.Auth} id={:signin_auth} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
