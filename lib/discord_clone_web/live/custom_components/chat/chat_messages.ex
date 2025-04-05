defmodule DiscordCloneWeb.CustomComponents.Chat.ChatMessages do
  alias DiscordClone.Messages.Messages
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- <button id="new-messages-btn" class="new-messages-btn hidden">New Messages</button>  --%>
    <div class="mb-24">
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
          type={@type}
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
      <div
        id="messages-container"
        class="flex flex-col-reverse mt-auto"
        phx-update="stream"
        phx-hook="InfiniteScroll"
      >
        <%= for {id, message} <- @streams.messages do %>
          <.live_component
            module={DiscordCloneWeb.CustomComponents.Chat.ChatItem}
            id={id}
            current_member={@member}
            member={message.member}
            content={message.content}
            file_url={message.file_url}
            file_type={message.file_type}
            deleted={message.deleted}
            timestamp={format_datetime(message.inserted_at)}
            is_updated={message.updated_at != message.inserted_at}
          />
        <% end %>
      </div>

      <.button class="fixed bottom-20 right-5 bg-blue-500 text-white px-4 py-2 border-none rounded-full cursor-pointer shadow-md text-sm hidden transition-opacity duration-300 hover:bg-blue-700">
        New Messages
      </.button>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:messages, assigns.messages)
     |> assign(:next_cursor, assigns.next_cursor)
     |> stream(:messages, assigns.messages, reset: true)
     |> assign(:next_cursor, assigns.next_cursor)}
  end

  defp format_datetime(datetime) do
    Timex.format!(datetime, "%Y-%m-%d %H:%M:%S", :strftime)
  end
end
