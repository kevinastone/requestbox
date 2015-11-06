defmodule Requestbox.RootController do
  use Requestbox.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end
end
