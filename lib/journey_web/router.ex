defmodule JourneyWeb.Router do
  use JourneyWeb, :router

  import JourneyWeb.UserAuth
  # import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JourneyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    # plug :basic_auth, username: "journey", password: "AmazingJourney@"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", JourneyWeb do
    pipe_through :browser

    get "/:provider", GoogleAuthController, :request
    get "/:provider/callback", GoogleAuthController, :callback
    post "/:provider/callback", GoogleAuthController, :callback
    delete "/logout", GoogleAuthController, :delete
  end

  # scope "/", JourneyWeb, host: Application.compile_env!(:journey, Journey.URLs)[:shortener_url] do
  scope "/", JourneyWeb, host: "sg.jou.im" do
    # pipe_through :browser

    get "/:code", URLController, :url_redirect
  end

  scope "/", JourneyWeb do
    pipe_through :browser

    get "/", PageController, :landing
  end

  scope "/", JourneyWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/home", PageController, :home
    get "/clients/bulk", ClientController, :bulk
    post "/clients/sync_fresh_sales", ClientController, :sync_fresh_sales
    get "/clients/get", ClientController, :get
    resources "/clients", ClientController

    resources "/browsings", BrowsingController
    resources "/visits", VisitController
    resources "/templates", TemplateController

    post "/emails/send_test_email", EmailController, :send_test_email
    post "/emails/:id/send", EmailController, :send
    resources "/emails", EmailController
    resources "/urls", URLController
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

  ## Authentication routes

  scope "/", JourneyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{JourneyWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", JourneyWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{JourneyWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", JourneyWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{JourneyWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
