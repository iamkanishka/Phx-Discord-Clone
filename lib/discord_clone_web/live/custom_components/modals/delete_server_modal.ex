defmodule DiscordCloneWeb.CustomComponents.Modals.DeleteServerModal do
  alias DiscordClone.Servers.Servers
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header>
        Delete Server
      </.header>

      <div class="text-center text-zinc-500">
        Are you sure you want to do this? <br />
        <span class="text-indigo-500 font-semibold">{@server.name}</span>
        will be permanently deleted.
      </div>

      <div class=" flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2  px-6 py-4">
        <div class="flex items-center justify-between w-full">
          <.button
            phx-click="on_close"
            phx-target={@myself}
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
          >
            Cancel
          </.button>

          <.button
            phx-click="on_delete_confirm"
            phx-target={@myself}
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
            phx-disable-with="Deleting..."

          >
            Delete
          </.button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign(:is_loading, false)}
  end

  @impl true
  def handle_event("on_close", _unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("on_delete_confirm", _unsigned_params, socket) do
    socket = assign(socket, :is_loading, true)

    socket =
      with {:redirect, path} <-
             Servers.delete_server_and_redirect(
               socket.assigns.user_id,
               socket.assigns.server.profile_id
             ) do
        socket =
          if String.contains?(path, "/auth/sign-in") do
            socket
            |> redirect(to: path)
          else
            socket
            |> push_navigate(to: path, replace: true)
          end

        socket
      else
        # {:ok, :no_server_found} ->
        #   IO.puts("No server found, show server creation UI")
        #   socket

        # {:error, changeset} ->
        #   IO.inspect(changeset, label: "Error creating profile")
        #   socket
        {:error, :unauthenticated} ->
          {:redirect, "/auth/logout"}

        # {:error, changeset} -> {:error, changeset}
        {:error, error} ->
          IO.inspect(error)
          socket |> assign(:invite_joining_status, false)
      end

    {:noreply, socket}
  end
end
