defmodule DiscordCloneWeb.CustomComponents.Modals.CreateChannelModal do
  alias DiscordClone.Channels.Channels
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
        <span class="text-2xl text-center font-bold"> Create Channel </span>
      </.header>

      <.simple_form
        for={@form}
        id="channel-create-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="create_channel"
        class="space-y-8"
      >
        <div class="space-y-8 px-6">
          <.input field={@form[:channel_name]} type="text" label="Channel Name" />
          <.input
            field={@form[:channel_type]}
            type="select"
            label="channel Type"
            options={["TEXT", "AUDIO", "VIDEO"]}
            class="bg-zinc-300/50 border-0 focus:ring-0 text-black ring-offset-0 focus:ring-offset-0 capitalize outline-none"
            placeholder="Select a channel type"
          />
        </div>

        <div class="flex flex-row justify-center items-center">
          <.button
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
            phx-disable-with="Creating..."
          >
            Create
          </.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
     {:ok, socket |> assign(assigns) |> assign(:is_loading, false) |> assign_form()}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end

  @impl true
  def handle_event("validate", unsigned_params, socket) do
    IO.inspect(unsigned_params)
    {:noreply, socket}
  end

  @impl true
  def handle_event("create_channel", %{"form" => params}, socket) do
    socket = assign(socket, :is_loading, true)

    socket =
      with {:redirect, path} <-
             Channels.create_channel_and_redirect_to_server(
               socket.assigns.server.id,
               socket.assigns.user_id,
               params["channel_name"],
               String.to_atom(params["channel_type"])
             ) do
        socket
        |> push_navigate(to: path, replace: true)
      else
        {:ok, :no_server_found} ->
          IO.puts("No server found, show server creation UI")
          socket

        {:error, changeset} ->
          IO.inspect(changeset, label: "Error creating profile")
          socket
      end

    {:noreply,
     socket
     |> assign(:is_loading, false)}
  end
end
