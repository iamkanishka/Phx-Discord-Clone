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
      />
    </.modal>
    """
  end

  @impl true
  def mount(params, session, socket) do

    {:ok, socket
     |> assign(:file_content, %{
      "name" => "",
      "size" => "",
      "type" => "",
      "data" => "",
      "lastModified" => ""
     })
  }
  end

  @impl true
  def handle_event(
        "file_selected",
        %{"name" => name, "size" => size, "type" => type, "content" => base64_content},
        socket
      ) do
        IO.inspect(name)
        IO.inspect(size)
        IO.inspect(type)


    {:noreply,
     assign(socket, :file_content, %{
       "name" => name,
       "size" => size,
       "type" => type,
       "data" => base64_content,
       "lastModified" => DateTime.utc_now()
     })}
  end
end
