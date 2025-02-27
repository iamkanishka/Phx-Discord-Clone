defmodule DiscordCloneWeb.Invite.Invite do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component
      module={DiscordCloneWeb.CustomComponents.Modals.InviteModal}
      id={:invite_invite_modal}
    />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
