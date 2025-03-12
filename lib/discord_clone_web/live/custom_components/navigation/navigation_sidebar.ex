defmodule DiscordCloneWeb.CustomComponents.Navigation.NavigationSidebar do
  alias DiscordClone.Servers.Servers
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-4 flex flex-col items-center h-full text-primary w-full dark:bg-[#1E1F22] bg-[#E3E5E8] py-3">
      <.live_component
        module={DiscordCloneWeb.CustomComponents.Navigation.NavigationAction}
        id={:navigation_action}
      />
      <div class="h-[2px] bg-zinc-300 dark:bg-zinc-700 rounded-md w-10 mx-auto"></div>

      <.scroll_area class="flex-1 w-full">
        <div class="flex-1 w-full overflow-auto">
          <%= for server <- @servers do %>
            <div class="mb-4">
              <.live_component
                module={DiscordCloneWeb.CustomComponents.Navigation.NavigationItem}
                id={"server-#{server.id}"}
                name={server.name}
                server_id={server.id}
                image_url={server.image_url}
                current_server_id={@server_id}
              />
            </div>
          <% end %>
        </div>
      </.scroll_area>

          <!-- Dropdown menu   -->



    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    # IO.inspect(Servers.find_servers(assigns.user_id))
    IO.inspect(assigns)


    socket =
      case Servers.find_servers(assigns.user_id) do
        {:ok, servers} ->
          assign(socket, :servers, servers)

        # {:redirect, path} ->
        #   push_navigate(socket, to: path, replace: true)

        {:ok, :no_servers_found} ->
          IO.puts("No server found, show server creation UI")
          socket

        {:error, changeset} ->
          IO.inspect(changeset, label: "Error creating profile")
          socket
      end

    {:ok, socket
    |> assign(assigns)}
  end
end
