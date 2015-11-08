defmodule Requestbox.RequestController do
  use Requestbox.Web, :controller

  alias Requestbox.Request
  alias Requestbox.Session

  def get_body(conn, initial_body \\ "") do
    case read_body(conn) do
      {:ok, body, _conn} ->
        initial_body <> body
      {:more, body, conn} ->
        get_body(conn, initial_body <> body)
    end
  end

  def capture(conn, %{"session_id" => session_id}) do
    session_id = Requestbox.ID.decode(session_id)
    session = Repo.get!(Session, session_id)
    headers = Enum.map(conn.req_headers, fn {name, value} -> %Request.Header{name: name, value: value} end)

    # request.client_netaddr = conn.remote_ip
    changeset = Request.changeset(%Request{}, %{
      "session_id": session.id,
      "method": conn.method,
      "client_ip": :inet.ntoa(conn.remote_ip),
      "path": conn.request_path,
      "query_string": conn.query_string,
      "headers": headers,
      "body": get_body(conn, "")
    })

    case Repo.insert(changeset) do
      {:ok, request} ->
        conn
        |> text request.id
      {:error, changeset} ->
        conn
        |> text inspect(changeset.errors)
    end
  end
end
