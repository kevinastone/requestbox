import Config

if System.get_env("PHX_SERVER") do
  config :requestbox, RequestboxWeb.Endpoint, server: true
end

if config_env() == :prod do
  config :requestbox, RequestboxWeb.Endpoint,
    http: [port: {:system, "PORT"}],
    url: [scheme: "https", host: System.get_env("HOSTNAME"), port: 443],
    force_ssl: [rewrite_on: [:x_forwarded_proto]],
    cache_static_manifest: "priv/static/cache_manifest.json",
    secret_key_base: System.get_env("SECRET_KEY_BASE")

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []
  use_ssl = if System.get_env("ECTO_SSL"), do: true, else: false

  config :requestbox, Requestbox.Repo,
    url: System.get_env("DATABASE_URL"),
    ssl: use_ssl,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6
end
