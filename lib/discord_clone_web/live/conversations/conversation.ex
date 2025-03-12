defmodule DiscordCloneWeb.Conversations.Conversation do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
     <%!--
    <div class="bg-white dark:bg-[#313338] flex flex-col h-full">
     <.live_component
        module={MyAppWeb.ChatHeaderComponent}
        id="chat-header"
        image_url={@other_member.profile.image_url}
        name={@other_member.profile.name}
        server_id={@conversation.server_id}
        type="conversation"
      />
      <%= if @video do %>
        <.live_component
          module={MyAppWeb.MediaRoomComponent}
          id="media-room"
          chat_id={@conversation.id}
          video={true}
          audio={true}
        />
      <% else %>
        <.live_component
          module={MyAppWeb.ChatMessagesComponent}
          id="chat-messages"
          member={@current_member}
          name={@other_member.profile.name}
          chat_id={@conversation.id}
          type="conversation"
          api_url="/api/direct-messages"
          param_key="conversationId"
          param_value={@conversation.id}
          socket_url="/api/socket/direct-messages"
          socket_query={%{conversation_id: @conversation.id}}
        />
        <.live_component
          module={MyAppWeb.ChatInputComponent}
          id="chat-input"
          name={@other_member.profile.name}
          type="conversation"
          api_url="/api/socket/direct-messages"
          query={%{conversation_id: @conversation.id}}
        />
      <% end %>
    </div> --%>


    """
  end

  @impl true
  def mount(%{"conversation_id" => conversation_id} = params, _session, socket) do
    # conversation = Chat.get_conversation(conversation_id)
    # current_member = get_current_member(socket.assigns.current_user, conversation)
    # other_member = get_other_member(conversation, current_member)

    # {:ok,
    #  socket
    #  |> assign(:conversation, conversation)
    #  |> assign(:current_member, current_member)
    #  |> assign(:other_member, other_member)
    #  |> assign(:video, Map.get(params, "video", false))}
  end
end
