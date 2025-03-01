defmodule DiscordCloneWeb.CustomComponents.Shared.ProfileImageUpload do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
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

  @impl true
  def handle_event("save", unsigned_params, socket) do
    {:noreply, socket}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end
end
