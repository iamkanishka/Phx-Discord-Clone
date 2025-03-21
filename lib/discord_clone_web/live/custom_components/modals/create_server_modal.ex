defmodule DiscordCloneWeb.CustomComponents.Modals.CreateServerModal do
  use DiscordCloneWeb, :live_component
  alias DiscordClone.Servers.Servers

  alias Appwrite.Services.Storage

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black p-0 overflow-hidden">
      <.header>
        <div class="text-2xl text-center font-bold">Customize your server</div>

        <:subtitle>
          <div class="text-center text-zinc-500">
            Give your server a personality with a name and an image. You can always change it later.
          </div>
        </:subtitle>
      </.header>

      <.live_component
        module={DiscordCloneWeb.CustomComponents.Shared.FileUpload}
        id={:server_image_upload}
        value={@value}
        is_loading={@is_loading}
      />
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
            readonly={@is_loading}
          />
        </div>

        <:actions>
          <div class=" w-full text-center">
            <.button phx-disable-with="Creating...">Create</.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:is_loading, false)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form = Phoenix.HTML.FormData.to_form(%{}, as: :form)
    assign(socket, %{form: form})
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
      with {:ok, uploaded_file} <- upload_file(socket),
           server_image_url <- create_server_image_url(uploaded_file["$id"]),
           {:redirect, path} <-
             Servers.create_and_redirect_to_server(
               socket.assigns.user_id,
               server_image_url,
               params["server_name"]
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

    {:noreply,
     socket
     |> assign(:is_loading, false)}
  end

  defp upload_file(socket) do
    try do
      Storage.create_file(
        get_bucket_id(),
        nil,
        socket.assigns.value,
        nil
      )
    catch
      error -> IO.inspect(error)
    end
  end

  defp create_server_image_url(file_id) do
    "https://cloud.appwrite.io/v1/storage/buckets/#{get_bucket_id()}/files/#{file_id}/view?project=#{get_project_id()}&mode=admin"
  end

  defp get_bucket_id() do
    case Application.get_env(:appwrite, :bucket_id) do
      nil ->
        raise MissingBucketIdError

      bucket_id ->
        bucket_id
    end
  end

  defp get_project_id() do
    case Application.get_env(:appwrite, :project_id) do
      nil ->
        raise Appwrite.MissingProjectIdError

      project_id ->
        project_id
    end
  end
end
