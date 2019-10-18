import Config

config :requestbox, RequestboxWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("HOSTNAME"), port: 443],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :requestbox, Requestbox.Repo,
  url: System.get_env("DATABASE_URL")
