defmodule RequestboxWeb.Router do
  use Requestbox.Web, :router

  pipeline :browser do
    plug(Plug.MethodOverride)

    plug(
      Plug.Session,
      store: :cookie,
      key: "_requestbox_key",
      signing_salt: "i8W95jtn"
    )

    plug(:accepts, ~w(html json))
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :parsers do
    plug(
      Plug.Parsers,
      parsers: [:urlencoded, :multipart],
      pasthrough: ["*/"]
    )
  end

  pipeline :api do
    plug(
      Plug.Parsers,
      parsers: [:json, Absinthe.Plug.Parser],
      json_decoder: Poison
    )

    plug(Plug.Head)

    plug(:accepts, ["json"])
  end

  scope "/", RequestboxWeb do
    pipe_through([:parsers, :browser])

    get("/", SessionController, :index)
    post("/", SessionController, :create)
  end

  scope "/", RequestboxWeb do
    pipe_through(:browser)
    get("/:id", SessionController, :show)
  end

  scope "/req/:session_id", RequestboxWeb do
    alias Phoenix.Router.Scope
    forward("/", RequestController)
    # Hack a helper for this route
    @phoenix_routes Scope.route(__MODULE__, :match, :get, "/", RequestController, nil, [])
  end

  scope "/api" do
    pipe_through(:api)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: RequestboxWeb.Schema)

    forward("/", Absinthe.Plug, schema: RequestboxWeb.Schema)
  end
end
