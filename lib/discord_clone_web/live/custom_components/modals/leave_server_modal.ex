
defmodule DiscordCloneWeb.CustomComponents.Modals.LeaveServerModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
     <div class="bg-white text-black p-0 overflow-hidden">
      <.header>
        leave Server
      </.header>

      <div class="text-center text-zinc-500">
      Are you sure you want to leave <span class="font-semibold text-indigo-500">{@server?.name}</span>?
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
     <Dialog open={isModalOpen} onOpenChange={onClose}>
      <DialogContent class="bg-white text-black p-0 overflow-hidden">
        <DialogHeader class="pt-8 px-6">
          <DialogTitle class="text-2xl text-center font-bold">
            Leave Server
          </DialogTitle>
          <DialogDescription class="text-center text-zinc-500">
            Are you sure you want to leave <span class="font-semibold text-indigo-500">{server?.name}</span>?
          </DialogDescription>
        </DialogHeader>
        <DialogFooter class="bg-gray-100 px-6 py-4">
          <div class="flex items-center justify-between w-full">
            <Button
              disabled={isLoading}
              onClick={onClose}
              variant="ghost"
            >
              Cancel
            </Button>
            <Button
              disabled={isLoading}
              variant="primary"
              onClick={onClick}
            >
              Confirm
            </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
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
