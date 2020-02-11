defmodule RequestboxWeb.Router do
  use Requestbox.Web, :router

  pipeline :browser do
    plug(Plug.MethodOverride)

    plug(
      Plug.Session,
      store: :cookie,
      key: Application.fetch_env!(:requestbox, :session_key),
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
      json_decoder: Jason
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
    forward("/", RequestController)
    # Hack a helper for this route
    match(:get, "/", RequestController, nil)
  end

  scope "/api" do
    pipe_through(:api)

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: RequestboxWeb.Schema,
      interface: :playground
    )

    forward("/", Absinthe.Plug, schema: RequestboxWeb.Schema)
  end
end
