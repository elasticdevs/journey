defmodule JourneyWeb.Router do
  use JourneyWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JourneyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :basic_auth, username: "journey", password: "ElasticDevs@"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JourneyWeb do
    pipe_through :browser

    get "/", PageController, :home

    get "/clients/bulk", ClientController, :bulk
    post "/clients/refresh", ClientController, :refresh
    get "/clients/get", ClientController, :get
    resources "/clients", ClientController

    resources "/browsings", BrowsingController
    resources "/visits", VisitController
    resources "/templates", TemplateController

    post "/emails/send_test_email", EmailController, :send_test_email
    resources "/emails", EmailController
  end

  # Other scopes may use custom stacks.
  scope "/api", JourneyWeb do
    pipe_through :api

    post "/visits", VisitController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:journey, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JourneyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
