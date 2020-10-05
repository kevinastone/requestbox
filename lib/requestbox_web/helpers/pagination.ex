defmodule RequestboxWeb.Helpers.Pagination do
  def pagination_links(conn, pagination) do
    Phoenix.View.render(RequestboxWeb.PaginationView, "pagination.html", conn: conn, pagination: pagination)
  end

  defmacro __using__(_) do
    quote do: import(RequestboxWeb.Helpers.Pagination)
  end
end
