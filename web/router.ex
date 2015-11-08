defmodule AnyRoute do

  @http_methods [:get, :post, :put, :patch, :delete, :options, :connect, :trace, :head]

  defmacro __using__(_) do
    quote do
      import AnyRoute
    end
  end

  defmacro any(path, plug, plug_opts, options \\ []) do
    for verb <- @http_methods do
      quote do
        unquote(verb)(unquote(path), unquote(plug), unquote(plug_opts), unquote(options))
      end
    end
  end
end

defmodule Requestbox.Router do
  use Requestbox.Web, :router
  use AnyRoute

  pipeline :base do
    plug Plug.RequestId
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Requestbox, as: :root do
    pipe_through [:base, :browser]

    resources "/", SessionController, only: [:index, :create, :show]
  end

  scope "/req/:session_id", Requestbox do
    pipe_through [:base]

    any "", RequestController, :capture
  end
end

defmodule Requestbox.Router.TokenHelpers do
  # use Requestbox.ID.Helper, module: Requestbox.Router.Helpers, prefix: "test"
  # Requestbox.ID.helper Requestbox.Router.Helpers.request_path
  # Requestbox.ID.helper Requestbox.Router.Helpers.request_url

  def token_root_session_path(conn_or_endpoint, opts, vars \\ [], params \\ []) do
    vars = case vars do
      vars when is_list(vars) -> Enum.map(vars, fn var -> Requestbox.ID.encode(var) end)
      vars -> Requestbox.ID.encode(vars)
    end
    Requestbox.Router.Helpers.root_session_path(conn_or_endpoint, opts, vars, params)
  end

  def token_request_path(conn_or_endpoint, opts, vars \\ [], params \\ []) do
    vars = case vars do
      vars when is_list(vars) -> Enum.map(vars, fn var -> Requestbox.ID.encode(var) end)
      vars -> Requestbox.ID.encode(vars)
    end
    Requestbox.Router.Helpers.request_path(conn_or_endpoint, opts, vars, params)
  end

  def token_request_url(conn_or_endpoint, opts, vars \\ [], params \\ []) do
    vars = case vars do
      vars when is_list(vars) -> Enum.map(vars, fn var -> Requestbox.ID.encode(var) end)
      vars -> Requestbox.ID.encode(vars)
    end
    Requestbox.Router.Helpers.request_url(conn_or_endpoint, opts, vars, params)
  end
end
