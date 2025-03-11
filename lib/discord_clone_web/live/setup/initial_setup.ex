defmodule DiscordCloneWeb.Setup.InitialSetup do
alias DiscordClone.Servers.Servers
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
  @impl true
  def mount(_params, session, socket) do


    {:ok,
     socket
     |> assign_user_id(session)
     |> init_fie_content}
  end


  @impl true
  def handle_event(
        "file_selected",
        %{
          "name" => name,
          "size" => size,
          "type" => type,
          "content" => base64_content,
          "extras" => extras
        },
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

  defp assign_user_id(socket, session) do
    assign(socket, :user_id, session["current_user"].id)
  end

  defp init_fie_content(socket) do
    assign(socket, :file_content, %{
      "name" => "",
      "size" => "",
      "type" => "",
      "data" => "",
      "extras" => "",
      "lastModified" => ""
    })
  end
end
