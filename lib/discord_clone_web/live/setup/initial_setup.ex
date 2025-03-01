defmodule DiscordCloneWeb.Setup.InitialSetup do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.modal id="initial-modal" show on_cancel={JS.patch(~p"/")}>
      <.live_component
        module={DiscordCloneWeb.CustomComponents.Modals.InitialSetupModal}
        id={:initial_setup_modal}
      />
    </.modal>
    """
  end

  @impl true
  def mount(params, session, socket) do
    {:ok, socket}
  end
end
