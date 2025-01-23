defmodule DiscordCloneWeb.Channels.Channel do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    """
  end

  @impl true
  def mount(params, session, socket) do
    {:ok, socket}
  end
end
