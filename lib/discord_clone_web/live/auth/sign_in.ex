defmodule DiscordCloneWeb.Auth.SignIn do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-gradient-to-br from-[#C4B5FD] to-[#6B7280] overflow-hidden">
      <.live_component module={DiscordCloneWeb.CustomComponents.Auth.Auth} id={:signin_auth} />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
