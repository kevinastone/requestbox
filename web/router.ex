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
    alias Phoenix.Router.Scope
    forward "", RequestController
    # Hack a helper for this route
    @phoenix_routes Scope.route(__MODULE__, :match, :*, "", RequestController, nil, [])
  end
end
