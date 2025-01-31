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
  />


  <.scroll_area class="flex-1 px-3 h-64 w-80 border rounded-lg shadow">


        <div class="mt-2">

        <.live_component
    module={DiscordCloneWeb.CustomComponents.Server.ServerSearch}
    id={:server_search}
    data={@server_search_data}
  />

      </div>


        <div class="relative flex py-5 items-center">
   <div class="flex-grow border-t border-gray-400"></div>
   <%!-- <span class="flex-shrink mx-4 text-gray-400">Content</span> --%>
  <div class="flex-grow border-t border-gray-400"></div>
</div>

  <%= if @textChannels.length  %>

          <div class="mb-2">
            <ServerSection
              sectionType="channels"
              channelType={ChannelType.TEXT}
              role={role}
              label="Text Channels"
            />

            <.live_component
    module={DiscordCloneWeb.CustomComponents.Server.ServerSection}
    id={:server_section}
    sectionType="channels"
              channelType={"TEXT"}
              role={@role}
              label="Text Channels"

  />
            <div class="space-y-[2px]">
              {textChannels.map((channel) => (
                <ServerChannel
                  key={channel.id}
                  channel={channel}
                  role={role}
                  server={server}
                />
              ))}
            </div>
          </div>
        <% end %>




        {!!audioChannels?.length && (
          <div class="mb-2">
            <ServerSection
              sectionType="channels"
              channelType={ChannelType.AUDIO}
              role={role}
              label="Voice Channels"
            />
            <div class="space-y-[2px]">
              {audioChannels.map((channel) => (
                <ServerChannel
                  key={channel.id}
                  channel={channel}
                  role={role}
                  server={server}
                />
              ))}
            </div>
          </div>
        )}
        {!!videoChannels?.length && (
          <div class="mb-2">
            <ServerSection
              sectionType="channels"
              channelType={ChannelType.VIDEO}
              role={role}
              label="Video Channels"
            />
            <div class="space-y-[2px]">
              {videoChannels.map((channel) => (
                <ServerChannel
                  key={channel.id}
                  channel={channel}
                  role={role}
                  server={server}
                />
              ))}
            </div>
          </div>
        )}
        {!!members?.length && (
          <div class="mb-2">
            <ServerSection
              sectionType="members"
              role={role}
              label="Members"
              server={server}
            />
            <div class="space-y-[2px]">
              {members.map((member) => (
                <ServerMember
                  key={member.id}
                  member={member}
                  server={server}
                />
              ))}
            </div>
          </div>
        )}



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


    text_channels_data =  Enum.map(assigns.text_channels, fn channel ->
      %{
        id: channel.id,
        name: channel.name,
        icon: role_icon_map[channel.type]
      }
  end)

  audio_channels_data =  Enum.map(assigns.text_channels, fn channel ->
    %{
      id: channel.id,
      name: channel.name,
      icon: role_icon_map[channel.type]
    }
end)

video_channels_data =  Enum.map(assigns.text_channels, fn channel ->
  %{
    id: channel.id,
    name: channel.name,
    icon: role_icon_map[channel.type]
  }
end)

members_channels_data =  Enum.map(assigns.text_channels, fn channel ->
  %{
    id: channel.id,
    name: channel.name,
    icon: role_icon_map[channel.type]
  }
end)



    data=[
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
      },
    ]

    {:ok, socket|> assign(assigns) |> assign(server_search_data: data)}
  end
end
