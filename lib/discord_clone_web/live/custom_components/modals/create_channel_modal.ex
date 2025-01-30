
defmodule DiscordCloneWeb.CustomComponents.Modals.CreateChannelModal do
  use DiscordCloneWeb, :live_component

  def render(assigns) do
    ~H"""


    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
     <span class="text-2xl text-center font-bold"> Create Channel  </span>

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

        <:actions>
        <div class="bg-gray-100 px-6 py-4">
          <.button disabled={@isLoading} phx-disable-with="Creating...">Create</.button>

          </div>


        </:actions>
      </.simple_form>
    </div>





    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket|> assign(assigns)|>assign_form()}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end

end
