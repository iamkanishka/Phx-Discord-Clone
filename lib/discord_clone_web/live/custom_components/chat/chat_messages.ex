defmodule DiscordCloneWeb.CustomComponents.Chat.ChatMessages do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
     <div className="flex flex-col-reverse mt-auto">
        {data?.pages?.map((group, i) => (
          <Fragment key={i}>
            {group.items.map((message: MessageWithMemberWithProfile) => (
              <ChatItem
                key={message.id}
                id={message.id}
                currentMember={member}
                member={message.member}
                content={message.content}
                fileUrl={message.fileUrl}
                deleted={message.deleted}
                timestamp={format(new Date(message.createdAt), DATE_FORMAT)}
                isUpdated={message.updatedAt !== message.createdAt}
                socketUrl={socketUrl}
                socketQuery={socketQuery}
              />
            ))}
          </Fragment>
        ))}
      </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket|> assign(assigns)}
  end
end
