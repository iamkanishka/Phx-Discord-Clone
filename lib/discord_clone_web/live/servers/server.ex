defmodule DiscordCloneWeb.Servers.Server do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
