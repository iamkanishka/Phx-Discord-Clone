defmodule DiscordCloneWeb.CustomComponents.Chat.ChatInput do
  alias DiscordClone.DirectMessages.DirectMessages
  alias Appwrite.Services.Storage
  alias DiscordClone.Messages.Messages

  use DiscordCloneWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed bottom-0  z-[100] w-full">
      <div>
        <.simple_form
          for={@form}
          id="product-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
          class="space-y-8"
        >
          <div class="relative p-4 pb-6 flex w-full items-center  gap-2">
            <!-- Attachment Button -->
            <.button
              type="button"
              phx-click="message_file"
              phx-target={@myself}
              class="h-10 w-10 bg-zinc-500 dark:bg-zinc-400 hover:bg-zinc-600 dark:hover:bg-zinc-300 transition rounded-full flex justify-center items-center"
            >
              <.icon name="hero-plus" class="text-white dark:text-[#313338] w-5 h-5" />
            </.button>

    <!-- Input Field (Stretch to Full Width) -->
            <.input
              readonly={@is_loading}
              field={@form[:input_text]}
              type="text"
              class="px-14 py-6 bg-zinc-200/90 dark:bg-zinc-700/75 border-none border-0 focus-visible:ring-0 focus-visible:ring-offset-0 text-zinc-600 dark:text-zinc-200"
              placeholder={"Message #{if @type == "conversation", do:  @name, else: "#" <> @name}"}
            />

    <!-- Send Button -->
            <.button
              type="button"
              phx-click="save"
              phx-target={@myself}
              class="h-10 w-10 bg-blue-500 hover:bg-blue-600 transition rounded-full flex justify-center items-center"
            >
              <.icon name="hero-paper-airplane" class="text-white w-5 h-5" />
            </.button>
          </div>
        </.simple_form>
      </div>
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
  def handle_event("message_file", _unsigned_params, socket) do
    search_obj = %{
      label: "Chat_Input_FileUplaod",
      id: "chat_input_fileuplaod",
      module: DiscordCloneWeb.CustomComponents.Modals.MessageFileModal
    }

    send(self(), {:open_modal, {search_obj, %{}}})
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _unsigned_params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    socket = assign(socket, :is_loading, true)

    socket =
      if @type == "channel" do
        if socket.assigns.value["data"] != "" do
          with {:ok, uploaded_file} <- upload_file(socket),
               server_image_url <- create_server_image_url(uploaded_file["$id"]),
               {:ok, _message} <-
                 Messages.create_message(
                   socket.assigns.user_id,
                   socket.assigns.server_id,
                   socket.assigns.channel_id,
                   params["input_text"],
                   %{file_URL: server_image_url, file_type: socket.assigns.value["type"]}
                 ) do
            socket
          else
            {:error, error} ->
              {:error, error}

              socket
              |> assign(:is_loading, false)
          end
        else
          with {:ok, _message} <-
                 Messages.create_message(
                   socket.assigns.user_id,
                   socket.assigns.server_id,
                   socket.assigns.channel_id,
                   params["input_text"],
                   %{file_URL: nil, file_type: nil}
                 ) do
            socket
          else
            {:error, error} ->
              {:error, error}

              socket
              |> assign(:is_loading, false)
          end
        end
      else
        IO.inspect("Conversation Message Send")
        IO.inspect(socket.assigns.conversation_id, label: "Conversation ID")
        with {:ok, _message} <-
               DirectMessages.send_message(
                 socket.assigns.conversation_id,
                 socket.assigns.user_id,
                 params["input_text"],
                 %{file_URL: nil, file_type: nil}
               ) do
          socket
        else
          {:error, error} ->
              IO.inspect(error, label: "Error in Conversation Message Send")
            {:error, error}

            socket
            |> assign(:is_loading, false)
        end
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
