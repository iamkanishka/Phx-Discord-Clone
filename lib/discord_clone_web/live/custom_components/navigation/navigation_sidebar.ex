defmodule DiscordCloneWeb.CustomComponents.Navigation.NavigationSidebar do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <.tooltip side="right" align="center" label={@name}>
      <button phx-click="server_click" phx-value-id={@id} class="group relative flex items-center">
        <div class={[
          "absolute left-0 bg-primary rounded-r-full transition-all w-[4px]",
          @params["serverId"] != @id && "group-hover:h-[20px]",
          @params["serverId"] == @id && "h-[36px]" || "h-[8px]"
        ]} />
        <div class={[
          "relative group flex mx-3 h-[48px] w-[48px] rounded-[24px] group-hover:rounded-[16px] transition-all overflow-hidden",
          @params["serverId"] == @id && "bg-primary/10 text-primary rounded-[16px]"
        ]}>
          <img src={@image_url} alt="Channel" class="object-cover w-full h-full" />
        </div>
      </button>
    </.tooltip>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
