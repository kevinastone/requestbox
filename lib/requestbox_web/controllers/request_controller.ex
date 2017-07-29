defmodule RequestboxWeb.RequestController do
  # use Requestbox.Web, :controller
  use Plug.Builder
  alias Requestbox.Repo

  alias Requestbox.Request.Header
  alias Requestbox.Session

  plug Requestbox.BearerToken
  plug :load_session
  plug :query_token
  plug :check_token
  plug :action

  defp load_session(conn, _) do
    session_id = List.last conn.script_name
    session_id = Requestbox.Session.decode(session_id)
    assign(conn, :session, Repo.get!(Session, session_id))
  end

  defp query_token(conn, _) do
    conn = fetch_query_params conn
    case conn.query_params["token"] do
      nil -> conn
      token ->
        conn = assign(conn, :token, token)
        remaining_params = Map.delete(conn.query_params, "token")
        %Plug.Conn{conn | query_string: Plug.Conn.Query.encode(remaining_params), query_params: remaining_params}
    end
  end

  @doc """
  This attempts to perform a constant time compare.  I can't figure
  out how to get a zip_longest, so I just concatenated both strings
  together.
  """
  def secure_compare(a, b) do
    Enum.all?(
      Enum.zip(
        to_charlist(a <> b),
        to_charlist(b <> a)
      ), fn {a, b} -> a == b end
    )
  end

  defp _check_token(nil, _), do: true
  defp _check_token(_, nil), do: false
  defp _check_token(token, auth) do
    secure_compare(token, auth)
  end

  defp check_token(conn, _) do
    if _check_token(conn.assigns[:session].token, conn.assigns[:token]) do
      conn
    else
      conn |> send_resp(403, "Incorrect token") |> halt
    end
  end

  defp get_body(conn, initial_body \\ "") do
    case read_body(conn) do
      {:ok, body, _conn} ->
        {:ok, initial_body <> to_string(body), conn}
      {:more, body, conn} ->
        get_body(conn, initial_body <> to_string(body))
      {:error, reason} ->
        raise reason
    end
  end

  def init(_), do: true

  def action(conn, _) do
    headers = Enum.map(conn.req_headers, fn {name, value} -> %Header{name: name, value: value} end)
    {:ok, body, conn} = get_body(conn)

    changeset = Ecto.build_assoc(conn.assigns[:session], :requests, %{
      session_id: conn.assigns[:session].id,
      method: conn.method,
      client_ip: to_string(:inet.ntoa(conn.remote_ip)),
      path: conn.request_path,
      query_string: conn.query_string,
      headers: headers,
      body: body
    })

    case Repo.insert(changeset) do
      {:ok, request} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, request.id)
      {:error, changeset} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(400, inspect(changeset.errors))
        |> halt
    end
  end
end
