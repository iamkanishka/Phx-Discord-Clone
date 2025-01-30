
defmodule DiscordCloneWeb.CustomComponents.Modals.InviteModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <Dialog open={isModalOpen} onOpenChange={onClose}>
      <DialogContent class="bg-white text-black p-0 overflow-hidden">
        <DialogHeader class="pt-8 px-6">
          <DialogTitle class="text-2xl text-center font-bold">
            Invite Friends
          </DialogTitle>
        </DialogHeader>
        <div class="p-6">
          <Label
            class="uppercase text-xs font-bold text-zinc-500 dark:text-secondary/70"
          >
            Server invite link
          </Label>
          <div class="flex items-center mt-2 gap-x-2">
            <Input
              disabled={isLoading}
              class="bg-zinc-300/50 border-0 focus-visible:ring-0 text-black focus-visible:ring-offset-0"
              value={inviteUrl}
            />
            <Button disabled={isLoading} onClick={onCopy} size="icon">
              {copied
                ? <Check class="w-4 h-4" />
                : <Copy class="w-4 h-4" />
              }
            </Button>
          </div>
          <Button
            onClick={onNew}
            disabled={isLoading}
            variant="link"
            size="sm"
            class="text-xs text-zinc-500 mt-4"
          >
            Generate a new link
            <RefreshCw class="w-4 h-4 ml-2" />
          </Button>
        </div>
      </DialogContent>
    </Dialog>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
