defmodule Requestbox.Release do
  @app :requestbox

  def create do
    for repo <- repos() do
      case repo.__adapter__.storage_up(repo.config) do
        :ok ->
          IO.puts "The database for #{inspect repo} has been created"
        {:error, :already_up} ->
          IO.puts "The database for #{inspect repo} has already been created"
        {:error, term} when is_binary(term) ->
          IO.puts "The database for #{inspect repo} couldn't be created: #{term}"
        {:error, term} ->
          IO.puts "The database for #{inspect repo} couldn't be created: #{inspect term}"
      end
    end
  end

  def migrate do
    Application.ensure_all_started(:ecto)
    for repo <- repos() do
      # Ecto 3+
      # {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      # Ecto 2
      Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
    end
  end

  def rollback(repo, version) do
    # Ecto 3+
    # {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
    # Ecto 2
    Ecto.Migrator.run(repo, migrations_path(repo), :down, to: version)
  end

  @spec migrations_path(Ecto.Repo.t) :: String.t
  defp migrations_path(repo) do
    config = repo.config()
    priv = config[:priv] || "priv/#{repo |> Module.split |> List.last |> Macro.underscore}"
    app = Keyword.fetch!(config, :otp_app)
    Application.app_dir(app, Path.join(priv, "migrations"))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
