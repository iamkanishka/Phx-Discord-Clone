defmodule DiscordCloneWeb.Router do
  alias DiscordCloneWeb.Conversations
  alias DiscordCloneWeb.Channels
  use DiscordCloneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DiscordCloneWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", DiscordCloneWeb do
    pipe_through :browser

    live "/sign-in", Auth.SignIn, :show
    live "/sign-up", Auth.SignUp, :show

    get "/google", AuthController, :request
    get "/google/callback", AuthController, :callback
  end

  scope "/", DiscordCloneWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/invite/:invite_id", Invite.Invite, :show
    live "/initial-setup", Setup.InitialSetup, :show
    live "/servers/:server_id", Servers.Server, :show
    live "/servers/:server_id/channels/:channel_id", Servers.Server, :server_channel
    live "/servers/:server_id/conversation/:member_id",Servers.Server, :server_channel_conversation
    # live "/servers/:server_id/channels/:channel_id", Channels.Channel, :show
    # live "/servers/:server_id/conversation/:conversation_id", Conversations.Conversation, :show

  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscordCloneWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:discord_clone, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DiscordCloneWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
