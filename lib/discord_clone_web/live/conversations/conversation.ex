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
