defmodule RequestboxWeb.PaginationView do
  use Requestbox.Web, :view
  alias Plug.Conn.Query

  def page_link(conn, page) do
    query_string = conn.query_params |> Map.put("page", page) |> Query.encode()
    "#{conn.request_path}?#{query_string}"
  end
end
