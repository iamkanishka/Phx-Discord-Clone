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

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-8"
      >
        <div class="space-y-8 px-6">
          <div class="flex items-center justify-center text-center">
            <.input field={@form[:server_image]} type="file" label="Server Image" />
          </div>
        </div>

        <:actions>
          <.button class="bg-gray-100 px-6 py-4" phx-disable-with="Sending..." disabled={@isLoading}>
            Send
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
