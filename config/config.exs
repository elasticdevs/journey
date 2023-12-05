# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :journey,
  ecto_repos: [Journey.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :journey, JourneyWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: JourneyWeb.ErrorHTML, json: JourneyWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Journey.PubSub,
  live_view: [signing_salt: "937VmCbU"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :journey, Journey.Mailer, adapter: Swoosh.Adapters.Local
config :journey, Journey.GmailAPIMailer, adapter: Swoosh.Adapters.Gmail

config :journey, Journey.GmailSMTPMailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.gmail.com",
  username: "info@elasticdevs.io",
  password: System.get_env("GMAIL_LESS_SECURE_APP_PASSWORD"),
  ssl: false,
  # ssl_opts: [
  #   verify: :verify_peer,
  #   cacertfile: '/home/linuxuser/journey/priv/tls/ca-certificate.crt'
  # ],
  # tls: :always,
  auth: :always,
  port: 587,
  # dkim: [
  #   s: "default",
  #   d: "domain.com",
  #   private_key: {:pem_plain, File.read!("priv/keys/domain.private")}
  # ],
  retries: 2,
  no_mx_lookups: false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :client_ip]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :geoip,
  provider: :ip2locationio,
  cache_ttl_secs: 1800,
  api_key: "447907624DE4B3BA9E36816DD399F5A0"

# Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google,
       [default_scope: "email profile https://www.googleapis.com/auth/gmail.send"]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
