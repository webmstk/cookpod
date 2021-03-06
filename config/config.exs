# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cookpod,
  ecto_repos: [Cookpod.Repo]

# Configures the endpoint
config :cookpod, CookpodWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fC0xUr3y7OyzZARD3ubAJO42jsOsjEpL0JXjOhygPG9F7K4xzmnM+4txWFaA138d",
  render_errors: [view: CookpodWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookpod.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "MhfZzx6r"]

config :cookpod,
       CookpodWeb.Gettext,
       default_locale: "ru",
       locales: ~w(ru en)

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Slime template engine
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :phoenix,
  basic_auth: [
    username: System.get_env("BASIC_AUTH_USERNAME", "admin"),
    password: System.get_env("BASIC_AUTH_PASSWORD", "admin"),
    realm: "Need auth"
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
