
defmodule DiscordCloneWeb.CustomComponents.Modals.MembersModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""

     <div class="bg-white text-black overflow-hidden">

    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
      Manage Members
      </.header>

      <div class="text-center text-zinc-500">
        {@server?.members?.length} Members
      </div>
      </div>
        <.scroll_area class="mt-8 max-h-[420px] pr-6">




        <%= for {member, index} <- Enum.with_index(@server?.members)do %>

        <div key={member.id} class="flex items-center gap-x-2 mb-6">

              <img   src={@member.profile.imageUrl} alt="Rounded avatar"  />
                <div class="flex flex-col gap-y-1">
                <div class="text-xs font-semibold flex items-center gap-x-1">
                  {member.profile.name}
                  {roleIconMap[member.role]}
                </div>
                <p class="text-xs text-zinc-500">
                  {member.profile.email}
                </p>
              </div>



          <%!-- <li
            phx-click="open_modal"
            phx-target={@myself}
            phx-value-index={index}
            phx-click="open_modal"
            phx-value-module={dropdown_option[:module]}
            phx-value-id={dropdown_option[:id]}
          >
            <a
              href="#"
              class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white "
            >
              {dropdown_option[:label]}
              <.icon name={"hero-#{dropdown_option[:icon]}"} class="w-4 h-4" />
            </a>
          </li> --%>



          <%= if @server.profileId != @member.profileId and @loadingId != @member.id %>



          <button
      id="dropdownDefaultButton"
      data-dropdown-toggle="dropdown"
      class="w-full text-md font-semibold px-3 flex items-center h-12 border-neutral-200 dark:border-neutral-800 border-b-2 hover:bg-zinc-700/10 dark:hover:bg-zinc-700/50 transition"
      type="button"
    >
      <.icon name="hero-ellipsis-vertical" class="w-4 h-4" />
    </button>


          <div
      id="dropdown"
      class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow-sm w-44 dark:bg-gray-700 w-56 text-xs font-medium text-black dark:text-neutral-400 space-y-[2px]"
    >
      <ul
        class="py-2 text-sm text-gray-700 dark:text-gray-200"
        aria-labelledby="dropdownDefaultButton"
      >


      <li
            phx-click="open_modal"
            phx-target={@myself}
            phx-value-index={index}
            phx-click="open_modal"
            phx-value-module={dropdown_option[:module]}
            phx-value-id={dropdown_option[:id]}
          >
            <a
              href="#"
              class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white "
            >
              <.icon name="hero-shield-exclamation" class="w-4 h-4 mr-2" />
              <span>Role </span>

            </a>
          </li>


      </ul>


        <% end %>


        <% end %>



          {server?.members?.map((member) => (
            <div key={member.id} class="flex items-center gap-x-2 mb-6">
              <UserAvatar src={member.profile.imageUrl} />
              <div class="flex flex-col gap-y-1">
                <div class="text-xs font-semibold flex items-center gap-x-1">
                  {member.profile.name}
                  {roleIconMap[member.role]}
                </div>
                <p class="text-xs text-zinc-500">
                  {member.profile.email}
                </p>
              </div>
              {server.profileId !== member.profileId && loadingId !== member.id && (
                <div class="ml-auto">
                  <DropdownMenu>
                    <DropdownMenuTrigger>
                      <MoreVertical class="h-4 w-4 text-zinc-500" />
                    </DropdownMenuTrigger>
                    <DropdownMenuContent side="left">
                      <DropdownMenuSub>
                        <DropdownMenuSubTrigger
                          class="flex items-center"
                        >
                          <ShieldQuestion
                            class="w-4 h-4 mr-2"
                          />
                          <span>Role</span>
                        </DropdownMenuSubTrigger>
                        <DropdownMenuPortal>
                          <DropdownMenuSubContent>
                            <DropdownMenuItem
                              onClick={() => onRoleChange(member.id, "GUEST")}
                            >
                              <Shield class="h-4 w-4 mr-2" />
                              Guest
                              {member.role === "GUEST" && (
                                <Check
                                  class="h-4 w-4 ml-auto"
                                />
                              )}
                            </DropdownMenuItem>
                            <DropdownMenuItem
                              onClick={() => onRoleChange(member.id, "MODERATOR")}
                            >
                              <ShieldCheck class="h-4 w-4 mr-2" />
                              Moderator
                              {member.role === "MODERATOR" && (
                                <Check
                                  class="h-4 w-4 ml-auto"
                                />
                              )}
                            </DropdownMenuItem>
                          </DropdownMenuSubContent>
                        </DropdownMenuPortal>
                      </DropdownMenuSub>
                      <DropdownMenuSeparator />
                      <DropdownMenuItem
                        onClick={() => onKick(member.id)}
                      >
                        <Gavel class="h-4 w-4 mr-2" />
                        Kick
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </div>
              )}
              {loadingId === member.id && (
                <Loader2
                  class="animate-spin text-zinc-500 ml-auto w-4 h-4"
                />
              )}
            </div>
          ))}

      </DialogContent>
    </Dialog>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end
end
