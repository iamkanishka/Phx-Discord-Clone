defmodule DiscordCloneWeb.Layouts.ServerMainLayout do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-full">
      <div class="hidden md:flex h-full w-[72px] z-30 flex-col fixed inset-y-0">
        <.live_component
          module={DiscordCloneWeb.CustomComponents.Navigation.NavigationSidebar}
          id={:server_navigation_side_bar}
          user_id={@user_id}
          user_image={@user_image}
          server_id={@server_id}
        />
      </div>

      <main class="md:pl-[72px] h-full">
        <div class="h-full">
          <div class="hidden md:flex h-full w-60 z-20 flex-col fixed inset-y-0">
            <%!-- <ServerSidebar server_id={@server_id} /> --%>
            <.live_component
              module={DiscordCloneWeb.CustomComponents.Server.ServerSidebar}
              id={:server_side_bar}
              text_channels={[]}
              video_channels={[]}
              audio_channels={[]}
              members={[]}

              role={:guest}

            />
          </div>

          <main class="h-full md:pl-60">
            {render_slot(@inner_block)}
          </main>
        </div>
      </main>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

end
