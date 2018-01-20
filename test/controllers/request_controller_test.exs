defmodule RequestboxWeb.RequestControllerTest do
  use RequestboxWeb.ConnCase, async: true
  import RequestboxWeb.Router.Helpers
  alias Requestbox.Repo
  alias Requestbox.Request

  setup context do
    context = Map.put(context, :session, insert(:session))
    {:ok, context}
  end

  setup context do
    context = Map.put(context, :path, build_conn() |> request_path(nil, context.session))
    {:ok, context}
  end

  def make_request(conn, params_or_body \\ nil) do
    conn =
      conn
      |> dispatch(@endpoint, conn.method, conn.request_path, params_or_body)

    request_id = text_response(conn, 200)
    assert request_id
    request = Repo.get!(Request, request_id)
    request
  end

  test "GET unknown request" do
    session = build(:session, id: 9999)
    path = request_path(build_conn(), nil, session)

    try do
      conn = get(build_conn(), path)
      assert text_response(conn, 404)
    rescue
      Ecto.NoResultsError -> true
    end
  end

  test "Request with Token without credentials" do
    session =
      build(:session)
      |> with_token("abcd")
      |> insert()

    path = request_path(build_conn(), nil, session)

    build_conn()
    |> get(path)
    |> response(403)
  end

  test "Request with Token with header credentials" do
    session =
      build(:session)
      |> with_token("abcd")
      |> insert()

    path = request_path(build_conn(), nil, session)

    build_conn()
    |> put_req_header("authorization", "Bearer abcd")
    |> get(path)
    |> response(200)
  end

  test "Request with Token with invalid header credentials" do
    session =
      build(:session)
      |> with_token("abcd")
      |> insert()

    path = request_path(build_conn(), nil, session)

    build_conn()
    |> put_req_header("authorization", "Bearer xyz")
    |> get(path)
    |> response(403)
  end

  test "Request with Token with query credentials" do
    session =
      build(:session)
      |> with_token("abcd")
      |> insert()

    path = request_path(build_conn(), nil, session, token: "abcd")

    build_conn()
    |> get(path)
    |> response(200)
  end

  test "Request with Token with invalid query credentials" do
    session =
      build(:session)
      |> with_token("abcd")
      |> insert()

    path = request_path(build_conn(), nil, session, token: "xyz")

    build_conn()
    |> get(path)
    |> response(403)
  end

  test "Capture header request", context do
    request =
      build_conn(:get, context.path)
      |> put_req_header("x-header", "value")
      |> make_request

    assert request.session_id == context.session.id
    assert request.method == "GET"
    assert request.path == context.path
    assert request.headers == [%Request.Header{name: "x-header", value: "value"}]
  end

  test "Capture client ip request", context do
    conn = build_conn(:get, context.path)

    request =
      conn
      |> make_request

    assert request.path == context.path
    assert request.client_ip == "127.0.0.1"
  end

  test "Capture POST request", context do
    body = ~s({"key": "value"})

    request =
      build_conn(:post, context.path)
      |> put_req_header("content-type", "application/json")
      |> make_request(body)

    assert request.method == "POST"
    assert request.path == context.path
    assert request.body == body
  end
end
