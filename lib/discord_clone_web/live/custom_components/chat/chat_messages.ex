defmodule DiscordCloneWeb.CustomComponents.Chat.ChatMessages do
  alias DiscordClone.Messages.Messages
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="flex flex-col  justify-center items-center">
        <.icon name="hero-arrow-path" class="h-7 w-7 text-zinc-500 animate-spin my-4" />
        <p class="text-xs text-zinc-500 dark:text-zinc-400">
          Loading messages...
        </p>
         <.icon name="hero-server-crash" class="h-7 w-7 text-zinc-500 my-4" />
        <p clas="text-xs text-zinc-500 dark:text-zinc-400">
          Something went wrong!
        </p>

        <.live_component
          module={DiscordCloneWeb.CustomComponents.Chat.ChatWelcomeMessage}
          id={:chat_welcome_message}
          type="channel"
          name={@name}
        />
      </div>

      <%!-- <div clas="flex flex-col justify-center items-center ">
        <.icon name="hero-server-crash" class="h-7 w-7 text-zinc-500 my-4" />
        <p clas="text-xs text-zinc-500 dark:text-zinc-400">
          Something went wrong!
        </p>
      </div>


      <.live_component
        module={DiscordCloneWeb.CustomComponents.Chat.ChatWelcomeMessage}
        id={:chat_welcome_message}
        type="channel"
        name={@name}
      />
      --%>
      <div class="flex flex-col-reverse mt-auto">
        <%= for {message, index} <- Enum.with_index(@messages || []) do %>

            <.live_component
              module={DiscordCloneWeb.CustomComponents.Chat.ChatItem}
              id={message.id}
              current_member={@member}
              member={message.member}
              content={message.content}
              file_url={message.file_url}
              deleted={message.deleted}
              timestamp={format_datetime(message.inserted_at)}
              is_updated={message.updated_at != message.inserted_at}
            />

        <% end %>
      </div>

    </div>
    """
  end

  @impl true
  def update(assigns, socket) do

    %{messages: messages, next_cursor: next_cursor} = Messages.get_messages(assigns.channel_id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:messages, messages)
     |> assign(:next_cursor, next_cursor)
    }
  end

  defp format_datetime(datetime) do
    Timex.format!(datetime, "%Y-%m-%d %H:%M:%S", :strftime)
  end
end
