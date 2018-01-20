defmodule RequestboxWeb.SessionControllerTest do
  use RequestboxWeb.ConnCase, async: true

  test "GET /" do
    conn = get(build_conn(), "/")
    assert html_response(conn, 200)
  end

  test "Create Session" do
    session =
      build(:session)
      |> to_string_params()

    conn = post(build_conn(), "/", %{session: session})
    assert redirected_to(conn)
  end

  test "Create Session with token" do
    session =
      build(:session)
      |> with_token("abcd")
      |> to_string_params()

    conn = post(build_conn(), "/", %{session: session})
    assert redirected_to(conn)
  end

  test "GET Session" do
    session = insert(:session)
    path = build_conn() |> session_path(:show, session)

    conn =
      build_conn()
      |> put_req_header("accepts", "text/html")
      |> get(path)

    assert html_response(conn, 200)
  end

  test "GET Session with Vanity" do
    session = build(:session) |> insert()
    vanity = build(:vanity) |> with_session(session) |> insert()
    path = build_conn() |> session_path(:show, vanity.name)

    conn =
      build_conn()
      |> put_req_header("accepts", "text/html")
      |> get(path)

    assert html_response(conn, 200)
  end

  test "GET Session with Request" do
    session = insert(:request).session
    path = build_conn() |> session_path(:show, session)

    conn =
      build_conn()
      |> put_req_header("accepts", "text/html")
      |> get(path)

    assert html_response(conn, 200)
  end
end
