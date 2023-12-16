defmodule JourneyWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :journey

  plug Plug.RequestId, assign_as: :request_id
  plug RemoteIp
  plug CORSPlug
  plug JourneyWeb.Plugs.ClientIp
  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_journey_key",
    signing_salt: "+q7j3gm5",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :journey,
    gzip: false,
    only: JourneyWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :journey
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug JourneyWeb.Router

  # Note the use of character lists instead of Elixir strings!
  def ssloptions('staging.journey.im') do
    [
      keyfile: "/etc/letsencrypt/live/staging.journey.im/privkey.pem",
      certfile: "/etc/letsencrypt/live/staging.journey.im/fullchain.pem"
    ]
  end

  def ssloptions('journey.im') do
    [
      keyfile: "/etc/letsencrypt/live/journey.im/privkey.pem",
      certfile: "/etc/letsencrypt/live/journey.im/fullchain.pem"
    ]
  end

  def ssloptions('sg.jou.im') do
    [
      keyfile: "/etc/letsencrypt/live/sg.jou.im/privkey.pem",
      certfile: "/etc/letsencrypt/live/sg.jou.im/fullchain.pem"
    ]
  end

  def ssloptions('jou.im') do
    [
      keyfile: "/etc/letsencrypt/live/jou.im/privkey.pem",
      certfile: "/etc/letsencrypt/live/jou.im/fullchain.pem"
    ]
  end

  # Catch-all clause at the end, which uses the default config
  def ssloptions(_hostname),
    do: [
      keyfile: "/etc/letsencrypt/live/journey.im/privkey.pem",
      certfile: "/etc/letsencrypt/live/journey.im/fullchain.pem"
    ]
end
