defmodule DiscordCloneWeb.CustomComponents.Server.ServerSidebar do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full text-primary w-full dark:bg-[#2B2D31] bg-[#F2F3F5]">
      <.live_component
        module={DiscordCloneWeb.CustomComponents.Server.ServerHeader}
        id={:server_header}
        role={@role}
        is_admin={true}
      />
      <.scroll_area class="flex-1 px-3 h-64 w-80 border rounded-lg shadow">
        <div class="mt-2">
          <.live_component
            module={DiscordCloneWeb.CustomComponents.Server.ServerSearch}
            id={:server_search}
            data={@server_search_data}
            is_admin={true}
            is_moderator={true}

          />
        </div>

        <div class="relative flex py-5 items-center">
          <div class="flex-grow border-t border-gray-400"></div>
           <%!-- <span class="flex-shrink mx-4 text-gray-400">Content</span> --%>
          <div class="flex-grow border-t border-gray-400"></div>
        </div>

        <%= if @text_channels != [] do %>
          <div class="mb-2">
            <.live_component
              module={DiscordCloneWeb.CustomComponents.Server.ServerSection}
              id="text_channels"
              section_type="channels"
              channel_type="text"
              role={@role}
              label="Text Channels"
            />
            <div class="space-y-[2px]">
              <%= for channel <- @text_channels do %>
                <.live_component
                  module={DiscordCloneWeb.CustomComponents.Server.ServerChannel}
                  id={"text_channel_#{channel.id}"}
                  channel={channel}
                  role={@role}
                  server={@server}
                />
              <% end %>
            </div>
          </div>
        <% end %>

        <%= if @audio_channels != [] do %>
          <div class="mb-2">
            <.live_component
              module={DiscordCloneWeb.CustomComponents.Server.ServerSection}
              id="audio_channels"
              section_type="channels"
              channel_type="audio"
              role={@role}
              label="Voice Channels"
            />
            <div class="space-y-[2px]">
              <%= for channel <- @audio_channels do %>
                <.live_component
                  module={DiscordCloneWeb.CustomComponents.Server.ServerChannel}
                  id={"audio_channel_#{channel.id}"}
                  channel={channel}
                  role={@role}
                  server={@server}
                />
              <% end %>
            </div>
          </div>
        <% end %>

        <%= if @video_channels != [] do %>
          <div class="mb-2">
            <.live_component
              module={DiscordCloneWeb.CustomComponents.Server.ServerSection}
              id="video_channels"
              section_type="channels"
              channel_type="video"
              role={@role}
              label="Video Channels"
            />
            <div class="space-y-[2px]">
              <%= for channel <- @video_channels do %>
                <.live_component
                  module={DiscordCloneWeb.CustomComponents.Server.ServerChannel}
                  id={"video_channel_#{channel.id}"}
                  channel={channel}
                  role={@role}
                  server={@server}
                />
              <% end %>
            </div>
          </div>
        <% end %>

        <%= if @members != [] do %>
          <div class="mb-2">
            <.live_component
              module={DiscordCloneWeb.CustomComponents.Server.ServerSection}
              id="members"
              section_type="members"
              role={@role}
              label="Members"
              server={@server}
            />
            <div class="space-y-[2px]">
              <%= for member <- @members do %>
                <.live_component
                  module={DiscordCloneWeb.CustomComponents.Server.ServerMember}
                  id={"member_#{member.id}"}
                  member={member}
                  server={@server}
                />
              <% end %>
            </div>
          </div>
        <% end %>
      </.scroll_area>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    role_icon_map = %{
      :guest => nil,
      :moderator => %{name: "shield_check", class: "h-4 w-4 ml-2 text-indigo-500"},
      :admin => %{name: "shield_alert", class: "h-4 w-4 ml-2 text-rose-500"}
    }

    text_channels_data =
      Enum.map(assigns.text_channels, fn channel ->
        %{
          id: channel.id,
          name: channel.name,
          icon: role_icon_map[channel.type]
        }
      end)

    audio_channels_data =
      Enum.map(assigns.text_channels, fn channel ->
        %{
          id: channel.id,
          name: channel.name,
          icon: role_icon_map[channel.type]
        }
      end)

    video_channels_data =
      Enum.map(assigns.text_channels, fn channel ->
        %{
          id: channel.id,
          name: channel.name,
          icon: role_icon_map[channel.type]
        }
      end)

    members_channels_data =
      Enum.map(assigns.text_channels, fn channel ->
        %{
          id: channel.id,
          name: channel.name,
          icon: role_icon_map[channel.type]
        }
      end)

    data = [
      %{
        label: "Text Channels",
        type: "channel",
        data: text_channels_data
      },
      %{
        label: "Voice Channels",
        type: "channel",
        data: audio_channels_data
      },
      %{
        label: "Video Channels",
        type: "channel",
        data: video_channels_data
      },
      %{
        label: "Members",
        type: "member",
        data: members_channels_data
      }
    ]

    {:ok,
     socket
     |> assign(assigns)
    |> assign(server_search_data: data)}
  end
end
