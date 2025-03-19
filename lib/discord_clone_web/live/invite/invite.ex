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


  def join_by_invite(socket, invite_code, profile_id) do
    # Assuming profile_id is stored in session
    # profile_id = get_session(conn, :profile_id)
    case Invites.join_server_by_invite(invite_code, profile_id) do
      {:ok, server_id} ->
        {:noreply,
         socket
         |> push_navigate(to: "/servers/#{server_id}", replace: true)}

      {:error, :server_not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid invite code.")
         |> push_navigate(to: "//initial-setup/#{profile_id}", replace: true)}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid invite code.")
         |> push_navigate(to: "/auth/sign-in", replace: true)}
    end
  end

end
