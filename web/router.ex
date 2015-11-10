defmodule Requestbox.Router do
  use Requestbox.Web, :router

  pipeline :browser do
    plug Plug.MethodOverride
    plug Plug.Session,
      store: :cookie,
      key: "_requestbox_key",
      signing_salt: "i8W95jtn"

    plug :accepts, ~w(html json)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :parsers do
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart]

  end

  pipeline :api do
    plug Plug.Parsers,
      parsers: [:json],
      json_decoder: Poison
    plug Plug.Head

    plug :accepts, ["json"]
  end

  scope "/", Requestbox, as: :root do
    pipe_through [:parsers, :browser]

    get "/", SessionController, :index
    post "/", SessionController, :create
  end

  scope "/:id", Requestbox, as: :root do
    pipe_through :browser
    get "", SessionController, :show
  end

  scope "/req/:session_id", Requestbox do
    forward "", RequestController
  end
end

defmodule Requestbox.Router.TokenHelpers do

  def token_root_session_path(conn_or_endpoint, opts, id \\ nil, params \\ []) do
    id = case id do
      nil -> nil
      id -> Requestbox.ID.encode(id)
    end
    Requestbox.Router.Helpers.root_session_path(conn_or_endpoint, opts, id, params)
  end

  def token_request_path(_conn_or_endpoint, _opts, session_id, params \\ []) do
    session_id = case session_id do
      nil -> nil
      session_id -> Requestbox.ID.encode(session_id)
    end
    url = Enum.join(["/req"|List.wrap(session_id)], "/")
    case params do
      [] -> url
      params -> url <> "?" <> Plug.Conn.Query.encode(params)
    end
  end

  def token_request_url(conn_or_endpoint, opts, session_id, params \\ []) do
    Phoenix.Router.Helpers.url(__MODULE__,conn_or_endpoint) <> token_request_path(conn_or_endpoint, opts, session_id, params)
  end
end
