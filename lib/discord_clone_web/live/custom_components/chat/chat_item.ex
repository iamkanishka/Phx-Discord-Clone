defmodule DiscordCloneWeb.CustomComponents.Chat.ChatItem do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
     <div class="relative group flex items-center hover:bg-black/5 p-4 transition w-full">
      <div class="group flex gap-x-2 items-start w-full">
        <div phx-click="on_member_click" class="cursor-pointer hover:drop-shadow-md transition">
        <img
          class="h-8 w-8 md:h-8 md:w-8 mr-2 rounded-full"
          src="/docs/images/people/profile-picture-5.jpg"
          alt="Rounded avatar"
        />
        </div>
        <div class="flex flex-col w-full">
          <div class="flex items-center gap-x-2">
            <div class="flex items-center">
              <p  phx-click="on_member_click" class="font-semibold text-sm hover:underline cursor-pointer">
                {@member.profile.name}
              </p>
              <%!-- <ActionTooltip label={member.role}> --%>
              <.icon name={"hero-#{@icon[:name]}"} class={@icon[:class]} />

              <%!-- </ActionTooltip> --%>
            </div>
            <span class="text-xs text-zinc-500 dark:text-zinc-400">
              {@timestamp}
            </span>
          </div>
       <%= if @is_image do %>
            <a
              href={@fileUrl}
              target="_blank"
              rel="noopener noreferrer"
              class="relative aspect-square rounded-md mt-2 overflow-hidden border flex items-center bg-secondary h-48 w-48"
            >
              <img
                src={@fileUrl}
                alt={@content}
                fill="cover"
                class="object-cover"
              />
            </a>
            <% end %>

            <%= if @is_pdf do %>

            <div class="relative flex items-center p-2 mt-2 rounded-md bg-background/10">

              <.icon name="hero-document" class="h-10 w-10 fill-indigo-200 stroke-indigo-400" />

              <a
                href={@fileUrl}
                target="_blank"
                rel="noopener noreferrer"
                class="ml-2 text-sm text-indigo-500 dark:text-indigo-400 hover:underline"
              >
                PDF File
              </a>
            </div>
            <% end %>
            <%= if !@fileUrl && !@isEditing do %>

            <p class={"text-sm text-zinc-600 dark:text-zinc-300" <>
              if @deleted, do: "italic text-zinc-500 dark:text-zinc-400 text-xs mt-1", else: "" }>
              {@content}
            <%= if @isUpdated && @deleted do %>

                <span class="text-[10px] mx-2 text-zinc-500 dark:text-zinc-400">
                  (edited)
                </span>
                <% end %>

            </p>
            <% end %>

            <%= if !@fileUrl && @isEditing do %>




            <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="flex items-center w-full gap-x-2 pt-2"
      >

       <.input field={@form[:server_name]} type="text" label="Server Name"
        class="p-2 bg-zinc-200/90 dark:bg-zinc-700/75 border-none border-0 focus-visible:ring-0 focus-visible:ring-offset-0 text-zinc-600 dark:text-zinc-200"
                              placeholder="Edited message"
         />

        <:actions>


          <.button phx-disable-with="Creating..."  disabled={@isLoading}>Save</.button>


        </:actions>
        <span class="text-[10px] mt-1 text-zinc-400">
                Press escape to cancel, enter to save
              </span>
      </.simple_form>


            <% end %>

        </div>
      </div>

      <%= if @can_delete_message do %>
        <div class="hidden group-hover:flex items-center gap-x-2 absolute p-1 -top-2 right-5 bg-white dark:bg-zinc-800 border rounded-sm">
      <%= if @can_edit_message do %>

          <%!-- <ActionTooltip label="Edit"> --%>
            <.icon name="hero-edit" class="cursor-pointer ml-auto w-4 h-4 text-zinc-500 hover:text-zinc-600 dark:hover:text-zinc-300 transition" />
          <%!-- </ActionTooltip> --%>
        <% end %>

          <%!-- <ActionTooltip label="Delete"> --%>
            <.icon name="hero-trash" class="cursor-pointer ml-auto w-4 h-4 text-zinc-500 hover:text-zinc-600 dark:hover:text-zinc-300 transition" />
          <%!-- </ActionTooltip> --%>

         </div>

        <% end %>

    </div>
    """
  end

  def update(assigns, socket) do
    role_icon_map = %{
      :guest => nil,
      :moderator => %{name: "shield_check", class: "h-4 w-4 ml-2 text-indigo-500"},
      :admin => %{name: "shield_alert", class: "h-4 w-4 ml-2 text-rose-500"}
    }

    icon = Map.get(role_icon_map, assigns.member.role, nil)

    {:ok, socket |> assign(assigns) |> assign(icon: icon)}
  end
  @impl true
  def handle_event("on_member_click", unsigned_params, socket) do
    {:noreply, socket}
  end
end
