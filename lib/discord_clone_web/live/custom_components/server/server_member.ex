defmodule DiscordCloneWeb.CustomComponents.Server.ServerMember do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <.button
      onClick={onClick}
      class={"group px-2 py-2 rounded-md flex items-center gap-x-2 w-full hover:bg-zinc-700/10 dark:hover:bg-zinc-700/50 transition mb-1"
      <> if   @memberId === @member.id, do: "bg-zinc-700/20 dark:bg-zinc-700", else: ""
      }
    >
      <.icon name="hero-user" class="h-8 w-8 md:h-8 md:w-8" />
      <p class={   "font-semibold text-sm text-zinc-500 group-hover:text-zinc-600 dark:text-zinc-400 dark:group-hover:text-zinc-300 transition"
        <> if   @memberId === @member.id, do: "text-primary dark:text-zinc-200 dark:group-hover:text-white", else: ""
        }>
        {@member.profile.name}
      </p>
       <.icon name={"hero-#{@icon[:name]}"} class={@icon[:class]} />
    </.button>
    """
  end

  @impl true
  def update(assigns, socket) do
    role_icon_map = %{
      :guest => nil,
      :moderator => %{name: "shield_check", class: "h-4 w-4 ml-2 text-indigo-500"},
      :admin => %{name: "shield_alert", class: "h-4 w-4 ml-2 text-rose-500"}
    }

    icon = Map.get(role_icon_map, member.role, nil)

    {:ok, socket |> assign(assigns) |> assign(icon: icon)}
  end
end
