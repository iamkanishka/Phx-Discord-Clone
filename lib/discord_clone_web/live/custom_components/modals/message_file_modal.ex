defmodule DiscordCloneWeb.CustomComponents.Modals.MessageFileModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
        <span class="text-2xl text-center font-bold">Add an attachment</span>
        <:subtitle>
          <span class="text-center text-zinc-500">
            Send a file as a messages
          </span>
        </:subtitle>
      </.header>

      <.live_component
        module={DiscordCloneWeb.CustomComponents.Shared.FileUpload}
        id={:chat_file_upload}
        value={@value}
        is_loading={@is_loading}
      />
      <div class="flex flex-row justify-center items-center">
        <.button
          class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
          phx-disable-with="Uploading..."
        >
          Upload
        </.button>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(:is_loading, false) |> assign(assigns)}
  end
end
