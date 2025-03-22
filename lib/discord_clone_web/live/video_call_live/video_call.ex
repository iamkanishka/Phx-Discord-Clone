defmodule DiscordCloneWeb.VideoCallLive.VideoCall do
  alias DiscordCloneWeb.VideoCallLive.TwilioVideo
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @room_name do %>
        <div
          id="video-container"
          phx-hook="videoCall"
          data-room-name={@room_name}
          data-token={@token}
          data-identity={@identity}
        >
          <div id="local-video"></div>

          <div id="remote-video"></div>
           <button id="mute-audio">Mute Audio</button> <button id="mute-video">Mute Video</button>
        </div>
      <% else %>
        <button phx-click="create_room" >Create Room</button>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, room_name: nil, token: nil, identity: "user_identity")}
  end

  @impl true
  def handle_event("create_room", _params, socket) do
    # Call your Twilio API module to create a room and get token
    {:ok, token, room_name} = TwilioVideo.create_video_room(socket.assigns.identity)

    {:noreply, assign(socket, room_name: room_name, token: token)}
  end
end
