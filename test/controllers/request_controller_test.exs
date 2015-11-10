defmodule Requestbox.RequestControllerTest do
  use Requestbox.ConnCase
  import Requestbox.Router.TokenHelpers
  alias Requestbox.Repo
  alias Requestbox.Request
  alias Requestbox.Session

  def _session do
    case Repo.insert(%Session{}) do
      {:ok, session} -> session
    end
  end

  def _session(%Session{} = session) do
    case Repo.insert(session) do
      {:ok, session} -> session
    end
  end

  setup context do
    context = Dict.put context, :session, _session()
    {:ok, context}
  end

  setup context do
    context = Dict.put context, :path, conn() |> token_request_path(nil, context.session.id)
    {:ok, context}
  end

  def make_request(conn, params_or_body \\ nil) do
    conn = conn
    |> dispatch(@endpoint, conn.method, conn.request_path, params_or_body)
    request_id = text_response(conn, 200)
    assert request_id
    request = Repo.get!(Request, request_id)
    request
  end

  @tag :skip
  test "GET unknown request" do
    path = token_request_path(conn(), nil, 9999)
    conn = get(conn(), path)
    assert text_response(conn, 404)
  end

  test "Request with Token without credentials" do
    session = _session(%Session{token: "abcd"})
    path = token_request_path(conn(), nil, session.id)
    conn
    |> get(path)
    |> response(403)
  end

  test "Request with Token with header credentials" do
    session = _session(%Session{token: "abcd"})
    path = token_request_path(conn(), nil, session.id)
    conn
    |> put_req_header("authorization", "Bearer abcd")
    |> get(path)
    |> response(200)
  end

  test "Request with Token with invalid header credentials" do
    session = _session(%Session{token: "abcd"})
    path = token_request_path(conn(), nil, session.id)
    conn
    |> put_req_header("authorization", "Bearer xyz")
    |> get(path)
    |> response(403)
  end

  test "Request with Token with query credentials" do
    session = _session(%Session{token: "abcd"})
    path = token_request_path(conn(), nil, session.id, token: "abcd")
    conn
    |> get(path)
    |> response(200)
  end

  test "Request with Token with invalid query credentials" do
    session = _session(%Session{token: "abcd"})
    path = token_request_path(conn(), nil, session.id, token: "xyz")
    conn
    |> get(path)
    |> response(403)
  end

  test "Capture header request", context do
    request = conn(:get, context.path)
    |> put_req_header("x-header", "value")
    |> make_request

    assert request.session_id == context.session.id
    assert request.method == "GET"
    assert request.path == context.path
    assert request.headers == [%Request.Header{name: "x-header", value: "value"}]
  end

  test "Capture client ip request", context do
    conn = conn(:get, context.path)
    request = conn
    |> make_request

    assert request.path == context.path
    assert request.client_ip == "127.0.0.1"
  end

  test "Capture POST request", context do
    body = ~s({"key": "value"})

    request = conn(:post, context.path)
    |> put_req_header("content-type", "application/json")
    |> make_request(body)

    assert request.method == "POST"
    assert request.path == context.path
    assert request.body == body
  end
end
