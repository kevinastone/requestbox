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
      parsers: [:urlencoded, :multipart],
      pasthrough: ["*/"]

  end

  pipeline :api do
    plug Plug.Parsers,
      parsers: [:json],
      json_decoder: Poison
    plug Plug.Head

    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through [:parsers, :browser]

    get "/", Requestbox.SessionController, :index
    post "/", Requestbox.SessionController, :create
  end

  scope "/" do
    pipe_through :browser
    get "/:id", Requestbox.SessionController, :show
  end

  scope "/req/:session_id" do
    alias Phoenix.Router.Scope
    forward "/", Requestbox.RequestController
    # Hack a helper for this route
    @phoenix_routes Scope.route(__MODULE__, :match, :get, "/", RequestController, nil, [])
  end
end
