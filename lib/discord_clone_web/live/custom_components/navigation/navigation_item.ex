defmodule DiscordCloneWeb.CustomComponents.Navigation.NavigationItem do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%!-- <.tooltip side="bottom" align="center" label={@name}> --%>
        <button phx-click="server_click" class="group relative flex items-center">
          <!-- Left indicator bar -->
          <div class={[
            "absolute left-0 bg-primary rounded-r-full transition-all w-[4px]",
            @current_server_id != @server_id && "group-hover:h-[20px]",
            (@current_server_id == @server_id && "h-[36px]") || "h-[8px]"
          ]} />

    <!-- Main button content -->
          <div class={[
            "relative group flex mx-3 h-[48px] w-[48px] rounded-[24px] group-hover:rounded-[16px] transition-all overflow-hidden",
            @current_server_id == @server_id && "bg-primary/10 text-primary rounded-[16px]"
          ]}>
            <img src={@image_url} alt="Channel" class="object-cover w-full h-full" />
          </div>
        </button>
      <%!-- </.tooltip> --%>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    IO.inspect(assigns)

    {:ok,
     socket
     |> assign(assigns)}
  end

  def handle_event("server_click", _params, socket) do
    # Handle your click event here
    IO.puts("Server clicked: #{socket.assigns.id}")
    {:noreply, socket}
  end
end
