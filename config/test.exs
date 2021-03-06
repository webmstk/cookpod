use Mix.Config

# Configure your database
config :cookpod, Cookpod.Repo,
  username: System.get_env("DB_USER", "postgres"),
  password: System.get_env("DB_PASSWORD", "postgres"),
  database: System.get_env("DB_NAME", "cookpod") <> "_test",
  hostname: System.get_env("DB_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cookpod, CookpodWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
