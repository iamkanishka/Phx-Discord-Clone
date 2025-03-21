defmodule DiscordCloneWeb.CustomComponents.Modals.LeaveServerModal do
  alias DiscordClone.Servers.Servers
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header>
        leave Server
      </.header>

      <div class="text-center text-zinc-500">
        Are you sure you want to leave <span class="font-semibold text-indigo-500">{@server.name}</span>?
      </div>

      <div class=" flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2  px-6 py-4">
        <div class="flex items-center justify-between w-full">
          <.button
            phx-click="on_close"
            phx-target={@myself}
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
          >
            Cancel
          </.button>

          <.button
            phx-click="on_delete_confirm"
            phx-target={@myself}
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
            phx-disable-with="leaving..."
          >
            Leave
          </.button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def handle_event("on_close", _unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("on_leave_confirm", _unsigned_params, socket) do
    with {:ok, :member_removed} <- Servers.leave_server(socket.assigns.server.id, socket.assigns.server.profile_id) do
      # Redirect to logout route
      redirect(socket, to: "/auth/logout")
    else
      {:error, :server_not_found} -> redirect(socket, to: "/auth/logout")
      {:error, reason} -> {:error, reason}
    end

    {:noreply, socket}
  end
end
