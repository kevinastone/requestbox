defmodule Requestbox.SessionControllerTest do
  use Requestbox.ConnCase

  import Requestbox.Router.TokenHelpers

  alias Requestbox.Repo
  alias Requestbox.Session

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200)
  end

  test "POST /" do
    conn = post conn(), "/"
    assert redirected_to(conn)
  end

  test "GET Session" do

    {:ok, session} = Repo.insert(%Session{})
    path = conn() |> token_root_session_path(:show, session.id)
    conn = conn()
    |> put_req_header("accepts", "text/html")
    |> get(path)
    assert html_response(conn, 200)
  end
end
