defmodule DiscordCloneWeb.Channels.Channel do
  use DiscordCloneWeb, :live_view

  # alias MyApp.Chat
  # alias MyAppWeb.Components.{ChatHeader, ChatMessages, ChatInput, MediaRoom}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white dark:bg-[#313338] flex flex-col h-full">
    <ChatHeader name={@channel.name} server_id={@channel.server_id} type="channel" />
    </div>
    """
  end



  def mount(%{"channel_id" => channel_id}, _session, socket) do
    # channel = Chat.get_channel(channel_id)

    # socket =
    #   socket
    #   |> assign(:channel, channel)
    #   |> assign(:member, get_member(socket))

    # {:ok, socket}
  end

end
