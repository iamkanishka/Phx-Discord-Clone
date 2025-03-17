defmodule DiscordCloneWeb.CustomComponents.Search.SeverSearch do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="p-4 bg-gray-900 text-white w-96 rounded-lg shadow-lg">
        <input
          type="text"
          phx-debounce="300"
          phx-keyup="search"
          placeholder="Search all channels and members"
          class="w-full p-2 bg-gray-800 border border-gray-700 rounded-md text-white"
        />
        <div class="mt-4">
          <%= for {type, icon} <- [text: "#", voice: "🎤", video: "📹"] do %>
            <%= if Enum.any?(assigns.filtered_channels, &(&1.type == type)) do %>
              <h3 class="text-gray-400 mt-2">
                {String.capitalize(to_string(type))} Channels
              </h3>

              <%= for channel <- Enum.filter(assigns.filtered_channels, &(&1.type == type)) do %>
                <div class="p-2 bg-gray-800 mt-1 rounded-md flex items-center cursor-pointer hover:bg-gray-700">
                  <span class="mr-2">{icon}</span> {channel.name}
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
    channels = [
      %{type: :text, name: "general"},
      %{type: :voice, name: "test-audio"},
      %{type: :video, name: "test-video"}
    ]

    {:ok, assign(socket, search: "", channels: channels, filtered_channels: channels)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    filtered_channels =
      Enum.filter(socket.assigns.channels, fn ch ->
        String.contains?(String.downcase(ch.name), String.downcase(query))
      end)

    {:noreply, assign(socket, search: query, filtered_channels: filtered_channels)}
  end
end
