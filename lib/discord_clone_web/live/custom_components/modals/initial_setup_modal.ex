defmodule DiscordCloneWeb.CustomComponents.Modals.InitialSetupModal do
  use DiscordCloneWeb, :live_component
  alias Appwrite.Services.Storage
  alias Appwrite.MissingBucketIdError
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

      <.live_component
        module={DiscordCloneWeb.CustomComponents.Shared.FileUpload}
        id={:profile_image_upload}
        value={@value}
        is_loading={@is_loading}
      />
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
            readonly={@is_loading}
          />
        </div>

        <:actions>
          <div class=" w-full text-center">
            <.button phx-disable-with="Creating...">Create</.button>
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

  @impl true
  def handle_event("validate", unsigned_params, socket) do
    IO.inspect(unsigned_params)
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", _unsigned_params, socket) do
    socket = assign(socket, :is_loading, true)
    profile_image = Map.delete(socket.assigns.value, "extras")
    IO.inspect(profile_image)
    :inet_db.add_ns({8, 8, 8, 8})
      uploaded_file=
      Storage.create_file(
        get_bucket_id(),
        nil,
        socket.assigns.value,
        nil
      )

     IO.inspect(uploaded_file)

    {:noreply,
     socket
     |> assign(:is_loading, false)}
  end

  defp get_bucket_id() do
    case Application.get_env(:appwrite, :bucket_id) do
      nil ->
        raise MissingBucketIdError

      bucket_id ->
        bucket_id
    end
  end
end
