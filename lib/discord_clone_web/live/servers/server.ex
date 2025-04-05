defmodule DiscordCloneWeb.Servers.Server do
  alias DiscordClone.DirectMessages.DirectMessages
  alias DiscordClone.DirectMessages.DirectMessage
  alias DiscordClone.Conversations
  alias DiscordClone.Conversations.Conversations
  alias DiscordClone.Messages.Messages
  alias DiscordClone.Members.Members
  alias DiscordClone.Channels.Channels

  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%!-- <div class="h-full">
      <div class="hidden md:flex h-full w-[72px] z-30 flex-col fixed inset-y-0">
        <.live_component
          module={DiscordCloneWeb.CustomComponents.Navigation.NavigationSidebar}
          id={:server_side_bar}
          user_id={@user_id}
          user_image={@user_image}
          server_id={@server_id}
        />
      </div>

      <main class="md:pl-[72px] h-full"></main>
     </div> --%>
      <.live_component
        module={DiscordCloneWeb.Layouts.ServerMainLayout}
        id={:server_side_bar}
        user_id={@user_id}
        user_image={@user_image}
        server_id={@server_id}
      >
        <div class="bg-white dark:bg-[#313338] flex flex-col h-full me-6">
          <.live_component
            module={DiscordCloneWeb.CustomComponents.Chat.ChatHeader}
            id={"chat_header_#{@channel.id}"}
            name={@channel.name}
            serverId={@channel.server_id}
            is_video={false}
            user_image={@user_image}
            type="channel"
          />
          <%= case @channel.type do %>
            <% :TEXT -> %>
              <.live_component
                module={DiscordCloneWeb.CustomComponents.Chat.ChatMessages}
                id={"chat_#{if @chat_type == ~c"channel", do: @channel.id, else: @conversation.id}"}
                member={@member}
                name={if @chat_type == ~c"channel", do: @channel.name, else: @member.profile.name}
                user_id={@user_id}
                channel_id={if @chat_type == ~c"channel", do: @channel.id, else: ""}
                conversation_id={@conversation.id}
                server_id={if @chat_type == ~c"channel", do: @channel.server_id, else: ""}
                type={@chat_type}
                messages={@messages}
                next_cursor={@next_cursor}
              />
              <.live_component
                module={DiscordCloneWeb.CustomComponents.Chat.ChatInput}
                id={"chat_input-#{@channel.id}"}
                name={@channel.name}
                type={@chat_type}
                user_id={@user_id}
                channel_id={@channel.id}
                server_id={@channel.server_id}
                value={@file_content}
              />
              <%!--
        <% ":AUDIO" -> %>
          <.live_component module={MediaRoom}
            chat_id={@channel.id}
            video={false}
            audio={true}
          />

        <% ":VIDEO" -> %>
          <.live_component module={MediaRoom}
            chat_id={@channel.id}
            video={true}
            audio={true}
          />
            --%>
          <% end %>
        </div>
      </.live_component>
    </div>

    <%= if @selected_modal != nil  do %>
      <.modal id={"#{@selected_modal.id}"} show>
        <.live_component
          module={@selected_modal.module}
          id={"#{@selected_modal.id}-modal"}
          server={@server}
          value={
            if @selected_modal.id == "edit_server" or @selected_modal.id == "create_server" or
                 @selected_modal.id == "chat_input_fileuplaod",
               do: @file_content,
               else: %{}
          }
          user_id={@user_id}
          channel_id={@channel.id}
        />
      </.modal>
    <% end %>
    """
  end

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> assign(:server_id, params["server_id"])
     |> assign(:selected_modal, nil)
     |> assign_user_id(session)
     |> init_file_content()
     |> assign_user_profile_image(session)
     |> assign(:chat_type, "")
     |> assign(:messages, [])
     |> assign(:next_cursor, "")}
  end

  defp assign_user_id(socket, session) do
    assign(socket, :user_id, session["current_user"].id)
  end

  defp assign_user_profile_image(socket, session) do
    assign(socket, :user_image, session["current_user"].image)
  end

  @impl true
  def handle_info({:open_modal, {selected_option, server}}, socket) do
    # Send to another LiveView or component if needed
    #  send(self(), {:notify_layout, selected_option})
    {:noreply,
     socket
     |> assign(:selected_modal, selected_option)
     |> assign(:server, server)}
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    {:noreply, assign(socket, messages: [socket.assigns.messages | message])}
  end

  @impl true
  def handle_info({:new_conversation, conversation}, socket) do
    {:noreply, assign(socket, messages: [socket.assigns.conversation | conversation])}
  end

  defp init_file_content(socket) do
    assign(socket, :file_content, %{
      "name" => "",
      "size" => "",
      "type" => "",
      "data" => "",
      "extras" => "",
      "lastModified" => ""
    })
  end

  @impl true
  def handle_event(
        "file_selected",
        %{
          "name" => name,
          "size" => size,
          "type" => type,
          "content" => base64_content,
          "extras" => extras
        },
        socket
      ) do
    {:noreply,
     assign(socket, :file_content, %{
       "name" => name,
       "size" => size,
       "type" => type,
       "data" => base64_content,
       "extras" => extras,
       "lastModified" => DateTime.utc_now()
     })}
  end

  @impl true
  def handle_params(params, uri, socket) do
    socket =
      if String.contains?(uri, "channel") and params["channel_id"] do
        socket
        |> assign_channel_and_members(params)
      else
        socket
        |> assign_conversation_and_members(params)
      end

    {:noreply, socket}
  end

  defp assign_channel_and_members(socket, params) do
    with {:ok, member, profile_id} <-
           Members.get_member_by_server_and_user(params["server_id"], socket.assigns.user_id),
         {:ok, channel} <-
           Channels.get_channel_by_id(params["channel_id"]) do
      if connected?(socket),
        do: Phoenix.PubSub.subscribe(DiscordClone.PubSub, "channel:#{params["channel_id"]}")

      socket
      |> assign(:chat_type, "channel")
      |> assign(:channel, channel)
      |> assign(:member, member)
      |> load_messages()
    else
      {:error, error} ->
        # This now correctly handles errors
        {:error, error}
        socket
    end
  end

  defp load_messages(socket) do
    %{messages: messages, next_cursor: next_cursor} =
      Messages.get_messages(socket.assigns.channel.id)

    socket
    |> assign(:next_cursor, next_cursor)
    |> assign(:messages, messages)
  end

  defp assign_conversation_and_members(socket, params) do
    with {:ok, member, profile_id} <-
           Members.get_member_by_server_and_user(params["server_id"], socket.assigns.user_id),
         {:ok, conversation} <-
           Conversations.get_or_create_conversation(member.id, params["member_id"]) do
      other_member =
        if conversation.member_one.profile_id == profile_id,
          do: conversation.member_two,
          else: conversation.member_one

      if connected?(socket),
        do: Phoenix.PubSub.subscribe(DiscordClone.PubSub, "conversation:#{conversation.id}")

      socket
      |> assign(:chat_type, "conversation")
      |> assign(:conversation, conversation)
      |> assign(:member, other_member)
      |> load_conversations()
    else
      {:error, error} ->
        # This now correctly handles errors
        {:error, error}
        socket
    end
  end

  defp load_conversations(socket) do
    %{messages: messages, next_cursor: next_cursor} =
      DirectMessages.fetch_messages(socket.assigns.conversation.id)

    IO.inspect(messages, label: "Messages")

    socket
    |> assign(:next_cursor, next_cursor)
    |> assign(:messages, messages)
  end

end
