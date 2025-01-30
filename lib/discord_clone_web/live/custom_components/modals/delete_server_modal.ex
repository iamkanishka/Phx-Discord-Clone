defmodule DiscordCloneWeb.CustomComponents.Modals.DeleteServerModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header>
        Delete Server
      </.header>

      <div class="text-center text-zinc-500">
        Are you sure you want to do this? <br />
        <span class="text-indigo-500 font-semibold">{@server?.name}</span>
        will be permanently deleted.
      </div>

      <div class=" flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2 bg-gray-100 px-6 py-4">
        <div class="flex items-center justify-between w-full">
          <.button disabled={isLoading} phx-click="on_close" phx-target={@myself} class="ghost">
            Cancel
          </.button>

          <.button
            disabled={isLoading}
            class="primary"
            phc-click="on_delete_confirm"
            phx-target={@myself}
          >
            Confirm
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
  def handle_event("on_close", unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("on_delete_confirm", unsigned_params, socket) do
    {:noreply, socket}
  end
end
