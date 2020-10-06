defmodule Requestbox.Pagination do
  defstruct page: 0, last: 0
  import Ecto.Query

  alias Requestbox.Pagination

  @per_page 10
  @max_page 1000
  @page 1

  defmacro __using__(opts \\ []) do
    quote do
      def paginate(query, params \\ %{}, options \\ []) do
        opts = Keyword.merge(unquote(opts), options)
        Pagination.paginate(__MODULE__, query, params, opts)
      end
    end
  end

  def paginate(repo, query, params, opts) do
    paginate(repo, query, build_options(opts, params))
  end

  def paginate(repo, query, opts) do
    per_page = get_per_page(opts)

    total_count = get_total_count(opts[:total_count], repo, query)
    total_pages = get_total_pages(total_count, per_page)
    page = get_page(opts, total_pages)
    offset = get_offset(total_count, page, per_page)

    pagination = %Pagination{
      page: page,
      last: total_pages
    }

    {get_items(repo, query, per_page, offset), pagination}
  end

  defp get_items(repo, query, nil, _), do: repo.all(query)

  defp get_items(repo, query, limit, offset) do
    query
    |> limit(^limit)
    |> offset(^offset)
    |> repo.all()
  end

  defp get_offset(total_pages, page, per_page) do
    page =
      case page > total_pages do
        true -> total_pages
        _ -> page
      end

    case page > 0 do
      true -> (page - 1) * per_page
      _ -> page
    end
  end

  defp get_total_count(count, _repo, _query) when is_integer(count) and count >= 0, do: count

  defp get_total_count(_count, repo, query) do
    total_pages =
      query
      |> exclude(:preload)
      |> exclude(:order_by)
      |> total_count()
      |> repo.one()

    total_pages || 0
  end

  defp total_count(query) do
    query
    |> subquery()
    |> select(count("*"))
  end

  defp get_total_pages(_, nil), do: 1

  defp get_total_pages(count, per_page) do
    (count / per_page) |> Float.ceil() |> trunc
  end

  defp get_page(params, total_pages) do
    case params[:page] > params[:max_page] do
      true -> total_pages
      _ -> params[:page]
    end
  end

  defp get_per_page(params) do
    case Keyword.get(params, :per_page) do
      nil -> @per_page
      per_page -> per_page |> to_integer()
    end
  end

  defp get_max_page(params) do
    case Keyword.get(params, :max_page) do
      nil -> @max_page
      max_page -> max_page |> to_integer()
    end
  end

  defp build_options(opts, params) do
    page = Map.get(params, "page", @page) |> to_integer()
    per_page = get_per_page(opts)
    max_page = get_max_page(opts)
    Keyword.merge(opts, page: page, per_page: per_page, params: params, max_page: max_page)
  end

  defp to_integer(i) when is_integer(i), do: abs(i)

  defp to_integer(i) when is_binary(i) do
    case Integer.parse(i) do
      {n, _} -> n
      _ -> 0
    end
  end
end
