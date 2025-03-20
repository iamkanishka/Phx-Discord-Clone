defmodule DiscordCloneWeb.CustomComponents.Modals.EditServerModal do
  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header class="pt-8 px-6">
        <span class="text-2xl text-center font-bold">Edit your server</span>
        <:subtitle>
          <span class="text-center text-zinc-500">
            Give your server a personality with a name and an image. You can always change it later.
          </span>
        </:subtitle>
      </.header>

      <div class="py-8 ">
        <.live_component
          module={DiscordCloneWeb.CustomComponents.Shared.FileUpload}
          id={:profile_image_upload}
          value={@value}
          is_loading={@is_loading}
        />
      </div>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-8"
      >
        <div class="space-y-8 px-6">
          <.input
            field={@form[:server_name]}
            type="text"
            label="Server Name"
            class="bg-zinc-300/50 border-0 focus-visible:ring-0 text-black focus-visible:ring-offset-0"
            placeholder="Enter server name"
          />
        </div>

        <div class="flex flex-row justify-center items-center">
          <.button
            class="phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
            phx-disable-with="Updating..."
          >
            Update
          </.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:value, %{
       "name" => "",
       "size" => "",
       "type" => "",
       "data" => "",
       "extras" => "",
       "lastModified" => ""
     })
     |> assign(:is_loading, false)
     |> assign_form()
     |> assign_image_data()}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
  end

  def assign_image_data(socket) do
    if socket.assigns.value["data"] != "" do
      assign(socket, :value, socket.assigns.value)
    else
      assign(socket, :value, %{"data" => socket.assigns.server.image_url, "extras" => "image"})
    end
  end

  @impl true
  def handle_event("validate", unsigned_params, socket) do
    IO.inspect(unsigned_params)
    {:noreply, socket}
  end


  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    socket = assign(socket, :is_loading, true)

    socket =
      if String.contains?(socket.assigns.value["extras"], "data") do
        with {:ok, uploaded_file} <- upload_file(socket),
             profile_image_url <- create_profile_image_url(uploaded_file["$id"]),
             {:redirect, path} <-
               Servers.update_and_redirect_to_server(
                 socket.assigns.server.id,
                 socket.assigns.server.profile_id,
                 %{name: params["server_name"], image_url: profile_image_url}
               ) do
          socket
          |> push_navigate(to: path, replace: true)
        else
          {:ok, :no_server_found} ->
            IO.puts("No server found, show server creation UI")
            socket

          {:error, changeset} ->
            IO.inspect(changeset, label: "Error creating profile")
            socket
        end
      else
        with {:redirect, path} <-
               Servers.update_and_redirect_to_server(
                 socket.assigns.server.id,
                 socket.assigns.server.profile_id,
                 %{name: params["server_name"], image_url: socket.assigns.value["data"]}
               ) do
          socket
          |> push_navigate(to: path, replace: true)
        else
          {:ok, :no_server_found} ->
            IO.puts("No server found, show server creation UI")
            socket

          {:error, changeset} ->
            IO.inspect(changeset, label: "Error creating profile")
            socket
        end
      end

    {:noreply,
     socket
     |> assign(:is_loading, false)}
  end

end
