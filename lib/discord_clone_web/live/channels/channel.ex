defmodule DiscordCloneWeb.Channels.Channel do
  use DiscordCloneWeb, :live_view

  # alias MyApp.Chat
  # alias MyAppWeb.Components.{ChatHeader, ChatMessages, ChatInput, MediaRoom}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white dark:bg-[#313338] flex flex-col h-full">
    <ChatHeader name={@channel.name} server_id={@channel.server_id} type="channel" />

    <%= case @channel.type do %>
        <% "text" -> %>
          <.live_component module={ChatMessages}
            id={"chat_#{@channel.id}"}
            member={@member}
            name={@channel.name}
            chat_id={@channel.id}
            type="channel"
            api_url="/api/messages"
            socket_url="/api/socket/messages"
            socket_query={%{channel_id: @channel.id, server_id: @channel.server_id}}
            param_key="channelId"
            param_value={@channel.id}
          />
          <.live_component module={ChatInput}
            name={@channel.name}
            type="channel"
            api_url="/api/socket/messages"
            query={%{channel_id: @channel.id, server_id: @channel.server_id}}
          />

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
