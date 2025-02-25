defmodule DiscordCloneWeb.CustomComponents.Modals.InviteModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
        <span class="text-2xl text-center font-bold">Invite Friends</span>
      </.header>

      <div class="p-6">
        <.label class="uppercase text-xs font-bold text-zinc-500 dark:text-secondary/70">
          Server invite link
        </.label>

        <div class="flex items-center mt-2 gap-x-2">
          <div
            disabled={@isLoading}
            class="bg-zinc-300/50 border-0 focus-visible:ring-0 text-black focus-visible:ring-offset-0"
          >
            {@inviteUrl}
          </div>

          <.button disabled={@isLoading} phx.click="copy" phx-target={@myself} size="icon">
            <%= if @copied  do %>
              <.icon name="hero-check" class="w-4 h-4" />
            <% else %>
              <.icon name="hero-clipboard" class="w-4 h-4" />
            <% end %>
          </.button>
        </div>

        <.button
          phx.click="generate"
          phx-target={@myself}
          disabled={@isLoading}
          class="text-xs text-zinc-500 mt-4 link btn-sm"
        >
          Generate a new link <.icon name="hero-arrow-path" class="w-4 h-4 ml-2" />
        </.button>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def handle_event("generate", unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("copy", unsigned_params, socket) do
    {:noreply, socket}
  end
end
