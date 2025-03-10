defmodule DiscordCloneWeb.Setup.InitialSetup do
  use DiscordCloneWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.modal id="initial-modal" show on_cancel={JS.patch(~p"/")}>
      <.live_component
        module={DiscordCloneWeb.CustomComponents.Modals.InitialSetupModal}
        id={:initial_setup_modal}
        value={@file_content}
        user_id={@user_id}

      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, session, socket) do
  {:ok, socket
     |> assign(:user_id, session["current_user"].id)
     |> assign(:file_content, %{
      "name" => "",
      "size" => "",
      "type" => "",
      "data" => "",
      "extras" => "",
      "lastModified" => ""
     })
  }
  end

  @impl true
  def handle_event(
        "file_selected",
        %{"name" => name, "size" => size, "type" => type, "content" => base64_content, "extras" => extras},
        socket
      ) do
       {:noreply,
     assign(socket, :file_content, %{
       "name" => name,
       "size" => size,
       "type" => type,
       "data" => base64_content,
       "extras" => extras,
       "lastModified" => DateTime.utc_now()
     })}
  end
end
