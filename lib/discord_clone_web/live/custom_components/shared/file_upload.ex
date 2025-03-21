defmodule DiscordCloneWeb.CustomComponents.Shared.FileUpload do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @value["data"] == ""   do %>
        <div
          id="dropzone"
          class="flex items-center justify-center w-full h-40 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-gray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
        >
          <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-full">
            <div class="flex flex-col items-center justify-center pt-5 pb-6">
              <.icon name="hero-cloud-arrow-up" class="w-8 h-8 mb-4 text-gray-500 dark:text-gray-400" />
              <p class="mb-2 text-sm text-gray-500 dark:text-gray-400">
                <span class="font-semibold">Click to upload</span> or drag and drop
              </p>

              <p class="text-xs text-gray-500 dark:text-gray-400">
                PNG, JPG, or PDF
              </p>
            </div>

            <input
              id="dropzone-file"
              type="file"
              class="hidden"
              phx-hook="FileInput"
              name="inputfile"
              accept="image/*,application/pdf"
            />
          </label>
        </div>
      <% end %>

      <%= if @value["data"] != ""  && @file_type != "pdf" do %>
        <div class="flex flex-row items-center justify-center ">
          <div class="relative h-20 w-20">
            <!-- Loader -->
            <%= if @is_loading do %>
              <div
                class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-40 rounded-full"
                id="loader"
              >
                <div class="animate-spin h-6 w-6 border-2 border-white border-t-transparent rounded-full">
                </div>
              </div>
            <% end %>

    <!-- Image -->
            <img src={@file_data} class="rounded-full h-full w-full object-cover" />

    <!-- Clear button -->
            <%= if !@is_loading do %>
              <button
                phx-click="clear_file"
                phx-target={@myself}
                class="bg-rose-500 text-white p-0.5 rounded-full absolute top-0 right-0 shadow-sm"
                type="button"
              >
                <.icon name="hero-x-mark" class="h-4 w-4" />
              </button>
            <% end %>
          </div>
        </div>
      <% end %>

      <%= if  @value["data"] != "" && @file_type == "pdf" do %>
        <div class="flex flex-col items-center justify-center ">
          <div class="relative flex items-center p-2 mt-2 rounded-md bg-gray-100 dark:bg-gray-800">
            <.icon name="hero-document-text" class="h-10 w-10 fill-indigo-200 stroke-indigo-400" />
            <button
              phx-click="clear_file"
              phx-target={@myself}
              class="bg-rose-500 text-white p-0.5 rounded-full absolute -top-2 -right-2 shadow-sm"
              type="button"
            >
              <.icon name="hero-x-mark" class="h-4 w-4" />
            </button>
          </div>

          <div></div>

          <div>{@value["name"]}</div>
        </div>
      <% end %>
       <%!-- Please Added other types as well if required --%>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
   file_type = if String.contains?(assigns.value["extras"], "image"), do: "img", else: "pdf"

   file_data =
    if String.contains?(assigns.value["extras"], "data"),
      do: "#{assigns.value["extras"]},#{assigns.value["data"]}"  ,
      else: assigns.value["data"]

   {:ok,
     socket
     |> assign(assigns)
     |> assign(:file_type, file_type)
     |> assign(:file_data, file_data)}
  end

  @impl true
  def handle_event("clear_file", _unsigned_params, socket) do
    {:noreply,
     socket
     |> assign(:value, %{
       "data" => "",
       "extras" => "",
       "lastModified" => "",
       "name" => "",
       "size" => "",
       "type" => ""
     })}
  end
end
