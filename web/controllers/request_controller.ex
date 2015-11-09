defmodule Requestbox.RequestController do
  use Requestbox.Web, :controller

  alias Requestbox.Request
  alias Requestbox.Session

  def get_body(conn, initial_body \\ "") do
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
    # %{"session_id" => session_id} = conn.params
    session_id = List.last conn.script_name
    session_id = Requestbox.ID.decode(session_id)
    session = Repo.get!(Session, session_id)

    headers = Enum.map(conn.req_headers, fn {name, value} -> %Request.Header{name: name, value: value} end)
    {:ok, body, conn} = get_body(conn)

    changeset = Request.changeset(%Request{}, %{
      session_id: session.id,
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
