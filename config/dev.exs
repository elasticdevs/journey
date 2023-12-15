import Config

# Configure your database
config :journey, Journey.Repo,
  username: "postgres",
  password: "Epa3R1Oqce5napx",
  hostname: "localhost",
  database: "journey_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :journey, JourneyWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 80, protocol_options: [idle_timeout: 300_000]],
  https: [
    port: 443,
    protocol_options: [idle_timeout: 300_000],
    cipher_suite: :strong,
    keyfile: "/etc/letsencrypt/live/staging.journey.im/privkey.pem",
    certfile: "/etc/letsencrypt/live/staging.journey.im/fullchain.pem"
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "dJU9KQh72ij/56ci0Tkn/Zn83XS6oWruKZwuJTApkm8qZuOC2M8V+Q7uXwHMQfIu",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :journey, JourneyWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/journey_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :journey, dev_routes: true

# Do not include metadata nor timestamps in development logs
# config :logger, :console, format: "[$level] $message\n"
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :client_ip]

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Include HEEx debug annotations as HTML comments in rendered markup
config :phoenix_live_view, :debug_heex_annotations, true

# Disable swoosh api client as it is only required for production adapters.
# config :swoosh, :api_client, false

# URL Config
config :journey, Journey.URLs,
  website_url: "https://elasticdevs.io",
  shortener_url: "https://sg.jou.im" || "https://sg.eldv.io"

import_config "dev.secret.exs"
