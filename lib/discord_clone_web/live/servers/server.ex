defmodule DiscordCloneWeb.Servers.Server do
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
          value={if @selected_modal.id == "edit_server" or  @selected_modal.id == "create_server", do: @file_content, else: %{}}
          user_id={@user_id}
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

end
