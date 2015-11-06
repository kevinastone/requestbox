defmodule Requestbox.Router do
  use Requestbox.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    # plug :accepts, ["json"]
  end

  scope "/", Requestbox, as: :root do
    pipe_through :browser

    resources "/", SessionController, only: [:index, :create, :show]
  end

  scope "/api", Requestbox, as: :api do
    pipe_through :api

    get "/:session_id", RequestController, :capture
    post "/:session_id", RequestController, :capture
    patch "/:session_id", RequestController, :capture
    put "/:session_id", RequestController, :capture
    delete "/:session_id", RequestController, :capture
    head "/:session_id", RequestController, :capture
  end
end
