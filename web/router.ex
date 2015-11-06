defmodule Phoenixbin.Router do
  use Phoenixbin.Web, :router

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

  scope "/", Phoenixbin do
    pipe_through :browser

    get "/", RootController, :index
  end

  scope "/api", Phoenixbin do
    pipe_through :api
  end
end
