defmodule DiscordCloneWeb.CustomComponents.Search.SeverSearch do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="p-4 bg-white text-black dark:bg-gray-900 dark:text-white w-full  ">
      <form  phx-change="search" phx-target={@myself}>
        <input
          type="text"
          name="query"

          value={@search}
          placeholder="Search all channels and members"
          class="w-full p-2 bg-white text-black dark:bg-gray-800 dark:text-white    border border-gray-700 rounded-md "
        />
      </form>

        <div class="mt-4">
          <%= for section <- @filtered_channels do %>
            <%= if Enum.any?(section.data) do %>
              <h3 class="text-gray-400 mt-2">
                {section.label}
                <!-- "Text Channels", "Voice Channels", etc. -->
              </h3>

              <%= for channel <- section.data do %>
                <div class="p-2 bg-white text-black dark:bg-gray-800 dark:text-white mt-1 rounded-md flex items-center cursor-pointer hover:bg-gray-100">
                  <span class={channel.icon.class}>
                    <.icon name={"#{channel.icon.name}"} class={"#{channel.icon.class}"} />
                  </span>
                   {channel.name}
                </div>
              <% end %>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    %{server: %{server_search_data: server_search_data}} = assigns
   IO.inspect(server_search_data)
    {:ok,
     assign(socket,
       search: "",
       channels: server_search_data,
       filtered_channels: server_search_data
     )}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    IO.inspect(query, label: "Search Query")

    filtered_channels =
      socket.assigns.channels
      |> Enum.map(fn section ->
        %{section | data: Enum.filter(section.data, fn ch ->
          String.contains?(String.downcase(ch.name), String.downcase(query))
        end)}
      end)

    IO.inspect(filtered_channels, label: "Filtered Channels")

    {:noreply, assign(socket, search: query, filtered_channels: filtered_channels)}
  end

end
