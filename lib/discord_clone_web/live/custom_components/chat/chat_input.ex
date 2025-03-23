defmodule DiscordCloneWeb.CustomComponents.Chat.ChatInput do
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
        <div class="relative p-4 pb-6">
          <.button
            type="button"
            phx-click="message_file"
            phx-target={@myself}
            class="absolute top-7 left-8 h-[24px] w-[24px] bg-zinc-500 dark:bg-zinc-400 hover:bg-zinc-600 dark:hover:bg-zinc-300 transition rounded-full p-1 flex justify-center items-center "
          >
            <.icon name="hero-plus" class="text-white dark:text-[#313338]" />
          </.button>

          <.input
            disabled={@is_loading}
            field={@form[:value]}
            type="text"
            emoji
            class="px-14 py-6 bg-zinc-200/90 dark:bg-zinc-700/75 border-none border-0 focus-visible:ring-0 focus-visible:ring-offset-0 text-zinc-600 dark:text-zinc-200"
            placeholder={"Message #{if @type == "conversation", do:  @name, else: "#" <> @name}"}
          />
          <%!-- <div class="absolute top-7 right-8">
                    <EmojiPicker
                      onChange={(emoji: string) => field.onChange(`${field.value} ${emoji}`)}
                    />
                  </div> --%>
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

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end
end
