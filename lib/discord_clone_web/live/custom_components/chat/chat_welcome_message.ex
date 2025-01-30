defmodule DiscordCloneWeb.CustomComponents.Chat.ChatWelcomeMessage do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-2 px-4 mb-4">
      <%= if @type === "channel" do %>
        <div class="h-[75px] w-[75px] rounded-full bg-zinc-500 dark:bg-zinc-700 flex items-center justify-center">
          <.icon name="hero-hash" class="h-12 w-12 text-white" />
        </div>
      <% end %>

      <p class="text-xl md:text-3xl font-bold">
        {if @type === "channel", do: "Welcome to #", else: ""}{@name}
      </p>

      <p class="text-zinc-600 dark:text-zinc-400 text-sm">
        {if @type === "channel",
          do: "This is the start of the #{@name} channel.",
          else: "This is the start of your conversation with #{@name}"}
      </p>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end
end
