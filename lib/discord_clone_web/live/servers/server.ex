defmodule DiscordCloneWeb.Servers.Server do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-full">
      <div class="hidden md:flex h-full w-[72px] z-30 flex-col fixed inset-y-0">
        <.live_component
          module={DiscordCloneWeb.CustomComponents.Navigation.NavigationSidebar}
          id={:server_side_bar}
          user_id={@user_id}
          user_image={@user_image}
          server_id={@server_id}
        />
      </div>

      <main class="md:pl-[72px] h-full"></main>
    </div>
    """
  end

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket }
  end


end
