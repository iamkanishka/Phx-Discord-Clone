defmodule DiscordCloneWeb.CustomComponents.Chat.ChatVideoButton do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <ActionTooltip side="bottom" label={tooltipLabel}>
      <button onClick={onClick} className="hover:opacity-75 transition mr-4">
        <Icon className="h-6 w-6 text-zinc-500 dark:text-zinc-400" />
      </button>
    </ActionTooltip>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end
end
