defmodule Requestbox.SessionControllerTest do
  use Requestbox.ConnCase

  alias Requestbox.Repo
  alias Requestbox.Session

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200)
  end

  test "Create Session" do
    conn = post build_conn(), "/", %{"session" => %{}}
    assert redirected_to(conn)
  end

  test "Create Session with token" do
    conn = post build_conn(), "/", %{"session" => %{"token" => "abcd"}}
    assert redirected_to(conn)
  end

  test "GET Session" do

    {:ok, session} = Repo.insert(%Session{})
    path = build_conn() |> session_path(:show, session)
    conn = build_conn()
    |> put_req_header("accepts", "text/html")
    |> get(path)
    assert html_response(conn, 200)
  end

  test "GET Session with Request" do

    {:ok, session} = Repo.insert(%Session{})
    Repo.insert(Ecto.build_assoc(session, :requests, %{method: "GET", path: "/something"}))
    path = build_conn() |> session_path(:show, session)
    conn = build_conn()
    |> put_req_header("accepts", "text/html")
    |> get(path)
    assert html_response(conn, 200)
  end
end
