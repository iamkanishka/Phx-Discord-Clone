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
      <div class="pb-3 mt-auto flex items-center flex-col gap-y-4 relative">

      <button
        id="dropdownDefaultButton"
        data-dropdown-toggle="dropdown-menu"
        data-menu-id="naivgation_sidebar-profile-dropdown-menu"
        class="w-full text-md font-semibold px-3 flex items-center h-12 border-neutral-200 dark:border-neutral-800 border-b-2 hover:bg-zinc-700/10 dark:hover:bg-zinc-700/50 transition"
        phx-hook="DropdownToggle"
        type="button"
      >



        <img
          id="avatarButton"

          data-dropdown-toggle="userDropdown"
          data-dropdown-placement="bottom-start"
          class="w-10 h-10 rounded-full cursor-pointer"
          data-menu-id="naivgation_sidebar-profile-dropdown-menu"
          src={@user_image}
          alt="User dropdown"
        />
        </button>
        <div
          id="naivgation_sidebar-profile-dropdown-menu"
          class="z-[2000] absolute  bottom-5 left-12 hidden bg-white divide-y divide-gray-100 rounded-lg shadow-sm w-44 dark:bg-gray-700 dark:divide-gray-600 dropdown-menu"
        >
          <div class="px-4 py-3 text-sm text-gray-900 dark:text-white">
            <div>Bonnie Green</div>

            <div class="font-medium truncate">name@flowbite.com</div>
          </div>

          <ul class="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="avatarButton">
            <li>
              <a
                href="#"
                class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              >
                Dashboard
              </a>
            </li>

            <li>
              <a
                href="#"
                class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              >
                Settings
              </a>
            </li>

            <li>
              <a
                href="#"
                class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              >
                Earnings
              </a>
            </li>
          </ul>

          <div class="py-1">
            <a
              href="#"
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
            >
              Sign out
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
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

    {:ok,
     socket
     |> assign(assigns)}
  end
end
