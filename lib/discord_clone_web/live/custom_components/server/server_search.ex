defmodule DiscordCloneWeb.CustomComponents.Server.ServerSearch do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <button
      phx-click="serch_click"
      phx-target={@myself}
      class="group px-2 py-2 rounded-md flex items-center gap-x-2 w-full hover:bg-zinc-700/10 dark:hover:bg-zinc-700/50 transition"
    >
      <.icon name="hero-magnifying-glass" class="w-4 h-4 text-zinc-500 dark:text-zinc-400" />

      <p
          class="font-semibold text-sm text-zinc-500 dark:text-zinc-400 group-hover:text-zinc-600 dark:group-hover:text-zinc-300 transition"
        >
          Search
        </p>
        <kbd
          class="pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border bg-muted px-1.5 font-mono text-[10px] font-medium text-muted-foreground ml-auto"
        >
          <span class="text-xs">cmd</span>K
        </kbd>

    </button>
     <%!-- Add the modal in the parant live_view --%>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket|> assign(assigns)}
  end

  @impl true
  def handle_event("serch_click", unsigned_params, socket) do
    {:noreply, socket}
  end
end
