defmodule DiscordCloneWeb.CustomComponents.Server.ServerSection do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between py-2">
      <p class="text-xs uppercase font-semibold text-zinc-500 dark:text-zinc-400">
        {@label}
      </p>

      <%= if @role != "GUEST" and @sectionType == "channels" do %>
        <%!-- <ActionTooltip label="Create Channel" side="top"> --%>
        <.button
          phx-click="create_channel"
          phx-target={@myself}
          class="text-zinc-500 hover:text-zinc-600 dark:text-zinc-400 dark:hover:text-zinc-300 transition"
        >
          <.icon name="hero-plus" class="w-4 h-4" />
        </.button>
         <%!-- </ActionTooltip> --%>
      <% end %>

      <%= if @role != "ADMIN" and @sectionType == "members" do %>
        <%!-- <ActionTooltip label="Manage Members" side="top"> --%>
        <button
          phx-click="members"
          phx-target={@myself}
          class="text-zinc-500 hover:text-zinc-600 dark:text-zinc-400 dark:hover:text-zinc-300 transition"
        >
          <.icon name="hero-cog-6-tooth" class="w-4 h-4" />
        </button>
         <%!-- </ActionTooltip> --%>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("create_channel", unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("members", unsigned_params, socket) do
    {:noreply, socket}
  end
end
