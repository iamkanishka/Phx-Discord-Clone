defmodule DiscordCloneWeb.CustomComponents.Modals.EditServerModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
        <span class="text-2xl text-center font-bold">Edit your server</span>
        <:subtitle>
          <span class="text-center text-zinc-500">
            Give your server a personality with a name and an image. You can always change it later.
          </span>
        </:subtitle>
      </.header>

      <div class="py-8 ">
        <.live_component
          module={DiscordCloneWeb.CustomComponents.Shared.FileUpload}
          id={:profile_image_upload}
          value={@value}
          is_loading={@is_loading}
        />
      </div>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-8"
      >
        <div class="space-y-8 px-6">
          <.input
            field={@form[:server_name]}
            type="text"
            label="Server Name"
            class="bg-zinc-300/50 border-0 focus-visible:ring-0 text-black focus-visible:ring-offset-0"
            placeholder="Enter server name"
          />
        </div>

        <div class="flex flex-row justify-center items-center">
          <.button
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
            phx-disable-with="Updating..."
          >
            Update
          </.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:value, %{
       "name" => "",
       "size" => "",
       "type" => "",
       "data" => "",
       "extras" => "",
       "lastModified" => ""
     })
     |> assign(:is_loading, false)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end
end
