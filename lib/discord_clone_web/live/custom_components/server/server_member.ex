defmodule DiscordCloneWeb.CustomComponents.Server.ServerMember do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
     <.button
      phx-click="on_member_click"
      phx-target={@myself}
      class={"group px-2 py-2 rounded-md flex items-center gap-x-2 w-full hover:bg-zinc-700/10 dark:hover:bg-zinc-700/50 transition mb-1"
      <> if   @member_id == @member.id, do: "bg-zinc-700/20 dark:bg-zinc-700", else: ""
      }
    >
      <.icon name="hero-user" class="h-5 w-5 md:h-5 md:w-5" />
      <p class={   "font-semibold text-sm text-zinc-500 group-hover:text-zinc-600 dark:text-zinc-400 dark:group-hover:text-zinc-300 transition"
        <> if   @member_id == @member.id, do: "text-primary dark:text-zinc-200 dark:group-hover:text-white", else: ""
        }>
        {@member.profile.user.name}
      </p>
       <.icon name={"hero-#{@icon[:name]}"} class={@icon[:class]} />
    </.button>
    </div>

    """
  end


end
