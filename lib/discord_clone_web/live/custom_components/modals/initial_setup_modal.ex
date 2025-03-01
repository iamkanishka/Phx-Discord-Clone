defmodule DiscordCloneWeb.CustomComponents.Modals.InitialSetupModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header>
        <div class="text-2xl text-center font-bold">Customize your server</div>

        <:subtitle>
          <div class="text-center text-zinc-500">
            Give your server a personality with a name and an image. You can always change it later.
          </div>
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
          <.live_component
            module={DiscordCloneWeb.CustomComponents.Shared.ProfileImageUpload}
            id={:profile_image_upload}
          />
          <.input
            field={@form[:server_name]}
            type="text"
            label="Server Name"
            class="bg-zinc-300/50 border-0 focus-visible:ring-0 text-black focus-visible:ring-offset-0"
            placeholder="Enter server name"
          />
        </div>

        <:actions>
          <div class=" w-full text-center">
            <.button phx-disable-with="Creating..." disabled={@is_loading}>Create</.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:is_loading, false)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end

  def handle_event("save", unsigned_params, socket) do
    {:noreply, socket}
  end
end
