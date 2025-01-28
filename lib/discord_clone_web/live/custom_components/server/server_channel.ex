defmodule DiscordCloneWeb.CustomComponents.Server.ServerChannel do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <button
      phx-click="server_click"
      phx-target={@myself}
      class={"group px-2 py-2 rounded-md flex items-center gap-x-2 w-full hover:bg-zinc-700/10 dark:hover:bg-zinc-700/50 transition mb-1" <> if  @params?.channelId === @channel.id, do: "bg-zinc-700/20 dark:bg-zinc-700", else: ""}
    >
      <.icon name="hero-hashtag" class="flex-shrink-0 w-5 h-5 text-zinc-500 dark:text-zinc-400" />
      <p class={  "line-clamp-1 font-semibold text-sm text-zinc-500 group-hover:text-zinc-600 dark:text-zinc-400 dark:group-hover:text-zinc-300 transition"
          <> if  @channelId === @channel.id, do: "text-primary dark:text-zinc-200 dark:group-hover:text-white", else: ""

      }>
        {@channel.name}
      </p>
       <%!-- <%= if @channel.name != "general" and role != MemberRole.GUEST do %> --%>
      <%= if @channel.name != "general" and @role != "Guest" do %>
        <div class="ml-auto flex items-center gap-x-2">
          <%!-- <ActionTooltip label="Edit"> --%>
          <.icon
            name="hero-pencil"
            phx-click="edit_click"
            phx-target={@myself}
            class="hidden group-hover:block w-4 h-4 text-zinc-500 hover:text-zinc-600 dark:text-zinc-400 dark:hover:text-zinc-300 transition"
          /> <%!-- </ActionTooltip> --%> <%!-- <ActionTooltip label="Delete"> --%>
          <.icon
            name="hero-trash"
            phx-click="delete_click"
            phx-target={@myself}
            class="hidden group-hover:block w-4 h-4 text-zinc-500 hover:text-zinc-600 dark:text-zinc-400 dark:hover:text-zinc-300 transition"
          /> <%!-- </ActionTooltip> --%>
        </div>
      <% end %>

      <%= if @channel.name == "general" do %>
        <.icon
          name="hero-lock-closed"
          phx-click="delete_click"
          phx-target={@myself}
          class="ml-auto w-4 h-4 text-zinc-500 dark:text-zinc-400"
        />
      <% end %>
    </button>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def handle_event("server_click", unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("edit_click", unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_click", unsigned_params, socket) do
    {:noreply, socket}
  end
end
