defmodule DiscordCloneWeb.CustomComponents.Navigation.NavigationItem do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""

    <.tooltip side="right" align="center" label={@name}>
      <button phx-click="server_click" class="group relative flex items-center">
        <!-- Left indicator bar -->
        <div
          class={[
            "absolute left-0 bg-primary rounded-r-full transition-all w-[4px]",
            @params["serverId"] != @id && "group-hover:h-[20px]",
            @params["serverId"] == @id && "h-[36px]" || "h-[8px]"
          ]}
        />

        <!-- Main button content -->
        <div
          class={[
            "relative group flex mx-3 h-[48px] w-[48px] rounded-[24px] group-hover:rounded-[16px] transition-all overflow-hidden",
            @params["serverId"] == @id && "bg-primary/10 text-primary rounded-[16px]"
          ]}
        >
          <img
            src={@image_url}
            alt="Channel"
            class="object-cover w-full h-full"
          />
        </div>
      </button>
    </.tooltip>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    # Example assigns - adjust based on your actual data structure
    socket = assign(socket, %{
      name: "Server Name",    # Replace with your dynamic name
      id: "server123",        # Current server ID
      params: params,         # URL params
      image_url: "/images/server.jpg"  # Your image URL
    })
    {:ok, socket}
  end

  def handle_event("server_click", _params, socket) do
    # Handle your click event here
    IO.puts("Server clicked: #{socket.assigns.id}")
    {:noreply, socket}
  end
end
