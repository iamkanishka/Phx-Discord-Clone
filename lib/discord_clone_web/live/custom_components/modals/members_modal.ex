defmodule DiscordCloneWeb.CustomComponents.Modals.MembersModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black overflow-hidden">
      <div class="bg-white text-black p-0 overflow-hidden">
        <.header class="pt-8 px-6">
          Manage Members
        </.header>

        <div class="text-center text-zinc-500">
          {length(@server.members)} Members
        </div>
      </div>

      <.scroll_area class="mt-8 max-h-[420px]  ">
        <%= for {member, index} <- Enum.with_index(@server.members)do %>
          <div class="flex items-center gap-x-2 mb-6">
            <img src={member.profile.user.image} class="w-8 h-8 rounded-full" />
            <div class="flex flex-col gap-y-1">
              <div class="text-xs font-semibold flex items-center gap-x-1">
                {member.profile.user.name} <%!-- <%= role_icon(member.role) %> --%>
              </div>

              <p class="text-xs text-zinc-500">
                {member.profile.user.email}
              </p>
            </div>

            <%= if @server.profile_id != member.profile_id and @loading_id != member.id do %>
              <div class="relative">
                <button
                  id="memberdropdownButton"
                  data-dropdown-toggle="dropdown-menu"
                  data-menu-id={"dropdown-#{member.id}"}
                  class="text-zinc-500"
                  phx-hook="DropdownToggle"
                  type="button"
                >
                  <.icon name="hero-ellipsis-vertical" class="h-4 w-4" />
                </button>

                <div
                  id={"dropdown-#{member.id}"}
                  class="z-[5000] absolute  top-5 right-15 hidden  bg-white divide-y divide-gray-100 rounded-lg shadow-sm w-44 dark:bg-gray-700 w-56 text-xs font-medium text-black dark:text-neutral-400 space-y-[2px] dropdown-menu"
                >
                  <div class="py-1">
                    <button
                      phx-click="change_role"
                      phx-value-id={member.id}
                      phx-value-role="GUEST"
                      class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 w-full"
                    >
                      <.icon name="hero-shield" class="h-4 w-4 mr-2" /> Guest
                      <%= if member.role == :GUEST do %>
                        <.icon name="hero-check" class="h-4 w-4 ml-auto" />
                      <% end %>
                    </button>

                    <button
                      phx-click="change_role"
                      phx-value-id={member.id}
                      phx-value-role="MODERATOR"
                      class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 w-full"
                    >
                      <.icon name="hero-shield-check" class="h-4 w-4 mr-2" /> Moderator
                      <%= if member.role == :MODERATOR do %>
                        <.icon name="hero-check" class="h-4 w-4 ml-auto" />
                      <% end %>
                    </button>
                  </div>

                  <div class="border-t border-gray-200"></div>

                  <button
                    phx-click="kick_member"
                    phx-value-id={member.id}
                    class="flex items-center px-4 py-2 text-sm text-red-600 hover:bg-gray-100 w-full"
                  >
                    <.icon name="hero-gavel" class="h-4 w-4 mr-2" /> Kick
                  </button>
                </div>
              </div>
            <% end %>

            <%= if @loading_id == member.id do %>
              <.icon name="hero-loader" class="animate-spin text-zinc-500 ml-auto w-4 h-4" />
            <% end %>
          </div>
        <% end %>
      </.scroll_area>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign(:loading_id, "")}
  end

  @impl true
  def handle_event("change_role", %{"id" => id, "role" => role}, socket) do
    # Handle role change logic here
    {:noreply, socket}
  end

  @impl true
  def handle_event("kick_member", %{"id" => id}, socket) do
    # Handle kick logic here
    {:noreply, socket}
  end
end
