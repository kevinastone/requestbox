defmodule Phoenixbin.RootController do
  use Phoenixbin.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end
end
