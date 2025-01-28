defmodule DiscordCloneWeb.CustomComponents.Server.ServerHeader do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <button
      id="dropdownDefaultButton"
      data-dropdown-toggle="dropdown"
      class="w-full text-md font-semibold px-3 flex items-center h-12 border-neutral-200 dark:border-neutral-800 border-b-2 hover:bg-zinc-700/10 dark:hover:bg-zinc-700/50 transition"
      type="button"
    >
      {@server_name} <.icon name="hero-chevron-down" class="w-4 h-4" />
    </button>

    <!-- Dropdown menu -->
    <div
      id="dropdown"
      class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow-sm w-44 dark:bg-gray-700 w-56 text-xs font-medium text-black dark:text-neutral-400 space-y-[2px]"
    >
      <ul
        class="py-2 text-sm text-gray-700 dark:text-gray-200"
        aria-labelledby="dropdownDefaultButton"
      >
        <%= for {dropdown_option, index} <- Enum.with_index(@dropdown_options)do %>
          <li phx-click="open_modal" phx-target={@myself} phx-value-index={index}>
            <a
              href="#"
              class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white "
            >
              {dropdown_option[:label]}
              <.icon name={"hero-#{dropdown_option[:icon]}"} class="w-4 h-4" />
            </a>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    is_admin = assigns.is_admin
    is_moderator = assigns.is_moderator

    dropdown_options = [
      %{
        label: "Invite People",
        id: "invite_people",
        module: DiscordCloneWeb.CustomComponents.Modals.InviteModal,
        is_admin: is_admin,
        is_moderator: is_moderator,
        class: "text-indigo-600 dark:text-indigo-400 px-3 py-2 text-sm cursor-pointer",
        icon: "user-plus"
      },
      %{
        label: "Edit Server",
        id: "edit_server",
        module: DiscordCloneWeb.CustomComponents.Modals.EditServerModal,
        is_admin: is_admin,
        is_moderator: is_moderator,
        class: "px-3 py-2 text-sm cursor-pointer",
        icon: "cog-6-tooth"
      },
      %{
        label: "Members",
        id: "members",
        module: DiscordCloneWeb.CustomComponents.Modals.MembersModal,
        is_admin: is_admin,
        is_moderator: is_moderator,
        class: "px-3 py-2 text-sm cursor-pointer",
        icon: "users"
      },
      %{
        label: "Create Channel",
        id: "create_channel",
        module: DiscordCloneWeb.CustomComponents.Modals.CreateChannelModal,
        is_admin: is_admin,
        is_moderator: is_moderator,
        class: "px-3 py-2 text-sm cursor-pointer",
        icon: "plus-circle"
      },
      %{
        label: "Delete Server",
        id: "delete_channel",
        module: DiscordCloneWeb.CustomComponents.Modals.DeleteServerModal,
        is_admin: is_admin,
        is_moderator: is_moderator,
        class: "text-rose-500 px-3 py-2 text-sm cursor-pointer",
        icon: "trash"
      },
      %{
        label: "Leave Server",
        id: "leave_channel",
        module: DiscordCloneWeb.CustomComponents.Modals.LeaveServerModal,
        is_admin: is_admin,
        is_moderator: is_moderator,
        class: "text-rose-500 px-3 py-2 text-sm cursor-pointer",
        icon: "arrow-right-start-on-rectangle"
      }
    ]

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:dropdown_options, dropdown_options)}
  end

  @impl true
  def handle_event(event, unsigned_params, socket) do
  end
end
