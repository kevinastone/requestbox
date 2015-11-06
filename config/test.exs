use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenixbin, Phoenixbin.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenixbin, Phoenixbin.Repo,
  adapter: Sqlite.Ecto,
  database: "test.sqlite3",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
