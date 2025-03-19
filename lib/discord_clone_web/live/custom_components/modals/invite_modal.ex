defmodule DiscordCloneWeb.CustomComponents.Modals.InviteModal do
  alias DiscordClone.Servers.Servers
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header>
        <div class="text-2xl text-center font-bold">Invite Friends</div>
      </.header>

      <div class="py-6">
        <.label class="uppercase text-xs font-bold text-zinc-500 dark:text-secondary/70">
          Server invite link
        </.label>

        <div class="flex items-center mt-2  gap-x-2">
          <div  class=" flex-1 bg-zinc-300/50 border-0 focus-visible:ring-0 text-black text-sm focus-visible:ring-offset-0 p-3 rounded-lg"
          >
            {@invite_url}
          </div>

          <.button
            disabled={@invite_link_generation_status}
            phx-click="copy-invite-link"
            phx-hook="ClipboardCopy"
            data-clipboard={@invite_url}
            phx-target={@myself}
            size="icon"
          >
            <%= if @copied  do %>
              <.icon name="hero-check" class="w-4 h-4" />
            <% else %>
              <.icon name="hero-clipboard" class="w-4 h-4" />
            <% end %>
          </.button>
        </div>

        <.button
          phx-click="generate-invite-link"
          phx-target={@myself}
          phx-disable-with="Generating..."
          class="text-md text-white mt-4 link btn-sm"
        >
          Generate a new link
        </.button>
      </div>
    </div>
    """
  end

  @impl true
  @spec update(maybe_improper_list() | map(), any()) :: {:ok, any()}
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:is_loading, false)
     |> assign_invite_link(assigns.server.invite_code)
     |> assign(:copied, false)
     |> assign(:invite_link_generation_status, false)
     |> assign(assigns)}
  end


  @impl true
  def handle_event("copy-invite-link", _unsigned_params, socket) do
    # Set `copied` to `false` initially
    socket = assign(socket, :copied, true)

    # Schedule a message to update `copied` to `true` after 5 seconds
    Process.send_after(self(), :set_copied_true, 5000)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:set_copied_true, socket) do
    {:noreply, assign(socket, :copied, false)}
  end


  defp generate_invite_code(socket, server_id, profile_id) do
    case Servers.update_server_invite_code(server_id, profile_id) do
      {:ok, updated_server} ->
        socket |> assign_invite_link(updated_server.invite_code)

      {:error, message} ->
        IO.puts("Error updating invite code: #{message}")
        socket
    end
  end



  defp assign_invite_link(socket, invite_code) do
    socket
    |> assign(:invite_url, "#{DiscordCloneWeb.Endpoint.url()}/invite/#{invite_code}")
  end



end
