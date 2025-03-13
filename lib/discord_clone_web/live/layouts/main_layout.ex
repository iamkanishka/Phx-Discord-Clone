defmodule DiscordCloneWeb.Layouts.MainLayout do
  use DiscordCloneWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="h-full">
      <div class="hidden md:flex h-full w-60 z-20 flex-col fixed inset-y-0">
        <%!-- <ServerSidebar server_id={@server_id} /> --%>
      </div>

      <main class="h-full md:pl-60">
        {render_slot(@inner_block)}
      </main>
    </div>
    """
  end
end
