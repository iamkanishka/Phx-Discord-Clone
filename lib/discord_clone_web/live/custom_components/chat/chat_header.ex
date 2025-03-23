defmodule DiscordCloneWeb.CustomComponents.Chat.ChatHeader do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="text-md font-semibold px-3 flex items-center h-12 border-neutral-200 dark:border-neutral-800 border-b-2">
      <%= if @type === "channel" do %>
        <.icon name="hero-hashtag" class="w-5 h-5 text-zinc-500 dark:text-zinc-400 mr-2" />
      <% end %>

      <%= if @type == "conversation" do %>
        <img
          class="h-8 w-8 md:h-8 md:w-8 mr-2 rounded-full"
          src={@user_image}
          alt="Rounded avatar"
        />
      <% end %>

      <p class="font-semibold text-md text-black dark:text-white">
        {@name}
      </p>

      <div class="ml-auto flex items-center">
         <%= if @type === "conversation" do %>
          <button phx-click="video_click" phx-target={@myself} class="hover:opacity-75 transition mr-4">

        <.icon name={"hero-#{@video_icon}"} class="w-5 h-5 text-zinc-500 dark:text-zinc-400 mr-2" />

         </button>
         <% end %>

      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do

     video_icon = if assigns.is_video, do:  "video-camera", else: "video-camera-slash";

    {:ok, socket |> assign(assigns)|> assign(video_icon: video_icon)}

  end

  def handle_event("video_click", unsigned_params, socket) do
    {:noreply, socket}
  end

end
