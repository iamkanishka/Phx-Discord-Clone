defmodule DiscordCloneWeb.Auth.SignUp do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
      <div class="bg-gradient-to-br from-[#C4B5FD] to-[#6B7280] overflow-hidden">
      <.live_component module={DiscordCloneWeb.CustomComponents.Auth.Auth} id={:signup_auth} />
    </div>
    """
  end

  @impl true

  def mount(params, session, socket) do
    {:ok, socket}
  end
end
