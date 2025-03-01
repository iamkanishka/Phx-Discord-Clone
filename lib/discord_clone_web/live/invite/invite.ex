defmodule DiscordCloneWeb.Invite.Invite do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.modal   id="invite-modal" show on_cancel={JS.patch(~p"/")}>
    <.live_component
      module={DiscordCloneWeb.CustomComponents.Modals.InviteModal}
      id={:invite_invite_modal}
    />
    </.modal>
    """
  end

  @impl true
  def mount(params, session, socket) do
    {:ok, socket}
  end
end
