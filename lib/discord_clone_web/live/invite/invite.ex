defmodule DiscordCloneWeb.Invite.Invite do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
     <.modal id="invite-modal" show on_cancel={JS.patch(~p"/")}>
      <div class="flex justify-center items-center w-full h-48">
        <div class="relative">
          <!-- Image -->
          <img src="/images/discord_clone.png" alt="Profile" class="w-16 h-16 rounded-full" />

    <!-- Circular Wave Effect -->
          <%= if @invite_joining_status do %>
            <div class="absolute inset-0 flex justify-center items-center">
              <span class="absolute w-24 h-24 bg-blue-300 opacity-30 rounded-full animate-ping">
              </span>
              <span class="absolute w-16 h-16 bg-blue-400 opacity-50 rounded-full animate-ping delay-200">
              </span>
            </div>
          <% end %>
        </div>
      </div>
    </.modal>
    """
  end

  @impl true
  def mount(params, session, socket) do
    {:ok, socket}
  end
end
