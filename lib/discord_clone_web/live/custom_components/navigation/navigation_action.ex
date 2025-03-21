defmodule DiscordCloneWeb.CustomComponents.Navigation.NavigationAction do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.tooltip side="right" align="center" label="Add a server">
        <button phx-click="create_server" phx-target={@myself} class="group flex items-center">
          <div class="flex mx-3 h-[48px] w-[48px] rounded-[24px] group-hover:rounded-[16px] transition-all overflow-hidden items-center justify-center bg-background dark:bg-neutral-700 group-hover:bg-emerald-500">
            <!-- Using Heroicons Plus icon as SVG instead of component -->
            <.icon name="hero-plus" class="group-hover:text-white transition text-emerald-500" />
          </div>
        </button>
      </.tooltip>
    </div>
    """
  end

  @impl true
   def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end



  @impl true
  def handle_event("create_server", _unsigned_params, socket) do
    search_obj = %{
      label: "Create Server",
      id: "create_server",
      module: DiscordCloneWeb.CustomComponents.Modals.CreateServerModal
    }

    send(self(), {:open_modal, {search_obj, %{}}})

    {:noreply, socket}
  end

end
