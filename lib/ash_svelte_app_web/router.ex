defmodule AshSvelteAppWeb.Router do
  use AshSvelteAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshSvelteAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/mcp" do
    forward "/", AshAi.Mcp.Router,
      tools: [
        # list your tools here
        # :tool1,
        # :tool2,
        # For many tools, you will need to set the `protocol_version_statement` to the older version.
      ],
      protocol_version_statement: "2024-11-05",
      otp_app: :ash_svelte_app
  end

  scope "/", AshSvelteAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/library", Live.BooksLibrary
  end

  scope "/rpc", AshSvelteAppWeb do
    # or :browser if using session-based auth
    pipe_through :api

    post "/run", RpcController, :run
    post "/validate", RpcController, :validate
  end

  # Other scopes may use custom stacks.
  # scope "/api", AshSvelteAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_svelte_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AshSvelteAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Application.compile_env(:ash_svelte_app, :dev_routes) do
    import AshAdmin.Router

    scope "/admin" do
      pipe_through :browser

      ash_admin "/"
    end
  end
end
