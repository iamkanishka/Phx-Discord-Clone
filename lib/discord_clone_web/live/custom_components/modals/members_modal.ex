
defmodule DiscordCloneWeb.CustomComponents.Modals.MembersModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 z-10 bg-black bg-opacity-50 flex justify-center items-center">
      <div class="bg-white p-4 rounded-lg w-96">
        <h1 class="text-2xl font-semibold">Create Channel</h1>

        <form phx-submit="create_channel">
          <input
            type="text"
            name="channel_name"
            placeholder="Channel Name"
            class="w-full border border-gray-300 rounded-lg p-2 mt-2"
          />
          <button type="submit" class="bg-blue-500 text-white rounded-lg p-2 mt-2 w-full">
            Create
          </button>
        </form>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
