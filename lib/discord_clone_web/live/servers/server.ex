defmodule DiscordCloneWeb.Servers.Server do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component
      module={DiscordCloneWeb.CustomComponents.Navigation.NavigationSidebar}
      id={:server_side_bar}
    />
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
