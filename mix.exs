defmodule Requestbox.MixProject do
  use Mix.Project

  def project do
    [
      app: :requestbox,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: false],
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Requestbox, []},
      # applications: [
      #   :cowboy,
      #   :logger,
      #   :quantum,
      #   :timex,
      #   :tzdata,
      #   :gettext,
      #   :phoenix,
      #   :phoenix_html,
      #   :phoenix_ecto,
      #   :ecto,
      #   :postgrex,
      #   :sqlite_ecto2
      # ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5"},
      {:phoenix_html, "~> 2.13"},
      {:ecto, "~> 2.2"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, "~> 0.13"},
      {:sqlite_ecto2, "~> 2.3", only: [:dev, :test]},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.1"},
      {:plug, "~> 1.7"},
      {:quantum, ">= 1.5.0"},
      {:jason, "~> 1.0"},
      {:maptu, "~> 1.0"},
      {:ok, "~> 2.3"},
      {:timex_ecto, "~> 3.3"},
      {:timex, "~> 3.5"},
      {:hashids, "~> 2.0"},
      {:phoenix_pagination, "~> 0.5.0"},
      {:absinthe_ecto, "~> 0.1"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_relay, "~> 1.4"},
      {:distillery, "~> 2.0"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:ex_machina, "~> 2.1", only: :test},
      {:faker, "~> 0.9", only: :test},
      {:phoenix_live_reload, "~> 1.0", only: :dev}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      runserver: ["ecto.setup", "phx.server"]
    ]
  end
end
