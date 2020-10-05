defmodule RequestboxWeb.Helpers.Pagination do
  def pagination_links(conn, pagination) do
    pagination_data = Numerator.build(pagination, show_first: true, show_last: true, num_pages_shown: 5)
    Phoenix.View.render(RequestboxWeb.PaginationView, "pagination.html", conn: conn, pagination_data: pagination_data)
  end

  defmacro __using__(_) do
    quote do: import(RequestboxWeb.Helpers.Pagination)
  end
end
