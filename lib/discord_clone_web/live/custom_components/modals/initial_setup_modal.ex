defmodule DiscordCloneWeb.CustomComponents.Modals.InitialSetupModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
        <span class="text-2xl text-center font-bold">Customize your server</span>
        <:subtitle>
          <span class="text-center text-zinc-500">
            Give your server a personality with a name and an image. You can always change it later.
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

          <.input
            field={@form[:server_name]}
            type="text"
            label="Server Name"
            className="bg-zinc-300/50 border-0 focus-visible:ring-0 text-black focus-visible:ring-offset-0"
            placeholder="Enter server name"
          />
        </div>

        <:actions>
          <div className="bg-gray-100 px-6 py-4">
            <.button phx-disable-with="Creating..." disabled={@isLoading}>Create</.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign_form()}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end
end
