defmodule DiscordCloneWeb.Servers.Server do
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
        <div class="bg-white dark:bg-[#313338] flex flex-col h-full">
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
                id={"chat_#{@channel.id}"}
                member={@member}
                name={@channel.name}
                user_id={@user_id}
                channel_id={@channel.id}
                server_id={@channel.server_id}
                type="channel"
              />
              <.live_component
                module={DiscordCloneWeb.CustomComponents.Chat.ChatInput}
                id={"chat_input-#{@channel.id}"}
                name={@channel.name}
                type="channel"
                user_id={@user_id}
                channel_id={@channel.id}
                server_id={@channel.server_id}
                file={@file}
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

    <%= if @selected_modal != nil do %>
      <%!-- <.modal id={"#{@selected_modal.id}-modal"} show on_cancel={hide_modal("#{@selected_modal.id}-modal")}> --%>
      <.modal
        id={"#{@selected_modal.id}-modal"}
        show
        on_cancel={hide_modal("#{@selected_modal.id}-modal")}
      >
        <.live_component
          module={@selected_modal.module}
          id={"#{@selected_modal.id}"}
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
     |> assign(:file, nil)
     |> assign_user_id(session)
     |> init_file_content()
     |> assign_user_profile_image(session)}
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
  def handle_info({:message_file_url, file}, socket) do
    # Send to another LiveView or component if needed
    #  send(self(), {:notify_layout, selected_option})
    {:noreply,
     socket
     |> assign(:file, file)}
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
  def handle_params(params, _uri, socket) do
    {:noreply, socket |> assign_channel_and_mebers(params)}
  end

  defp assign_channel_and_mebers(socket, params) do
    with {:ok, member} <-
           Members.get_member_by_server_and_user(params["server_id"], socket.assigns.user_id),
         {:ok, channel} <-
           Channels.get_channel_by_id(params["channel_id"]) do
      socket
      |> assign(:channel, channel)
      |> assign(:member, member)
    else
      {:error, error} ->
        # This now correctly handles errors
        {:error, error}
    end
  end
end
