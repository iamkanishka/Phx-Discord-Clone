defmodule DiscordCloneWeb.CustomComponents.Shared.ProfileImageUpload do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div
        id="dropzone"
        class="flex items-center justify-center w-full h-40 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-gray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
      >
        <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-full">
          <div class="flex flex-col items-center justify-center pt-5 pb-6">
            <svg
              class="w-8 h-8 mb-4 text-gray-500 dark:text-gray-400"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 20 16"
            >
              <path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
              />
            </svg>

            <p class="mb-2 text-sm text-gray-500 dark:text-gray-400">
              <span class="font-semibold">Click to upload</span> or drag and drop
            </p>

            <p class="text-xs text-gray-500 dark:text-gray-400">
              SVG, PNG, JPG, or GIF (MAX. 800x400px)
            </p>
          </div>

          <input id="dropzone-file" type="file" class="hidden" phx-hook="FileInput" name="inputfile" />
        </label>
      </div>

      <%= if @value && @file_type != "pdf" do %>
        <div class="relative h-20 w-20">
          <img src={@file_data} alt="Upload" class="rounded-full h-full w-full object-cover" />
          <button
            phx-click="clear_file"
            class="bg-rose-500 text-white p-1 rounded-full absolute top-0 right-0 shadow-sm"
            type="button"
          >
            <.icon name="hero-x-mark" class="h-4 w-4" />
          </button>
        </div>
      <% end %>

      <%= if @value && @file_type == "pdf" do %>
        <div class="relative flex items-center p-2 mt-2 rounded-md bg-gray-100 dark:bg-gray-800">
          <.icon name="file" class="h-10 w-10 fill-indigo-200 stroke-indigo-400" />
          <a
            href={@value}
            target="_blank"
            rel="noopener noreferrer"
            class="ml-2 text-sm text-indigo-500 dark:text-indigo-400 hover:underline"
          >
            {@value}
          </a>

          <button
            phx-click="clear_file"
            class="bg-rose-500 text-white p-1 rounded-full absolute -top-2 -right-2 shadow-sm"
            type="button"
          >
            <.icon name="hero-x-mark" class="h-4 w-4" />
          </button>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    IO.inspect(assigns)
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:file_type, "img")
     |> assign(:file_data, assigns.value[:data])

     |> assign(:is_loading, false)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", unsigned_params, socket) do
    IO.inspect(unsigned_params)
    {:noreply, socket}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end
end
