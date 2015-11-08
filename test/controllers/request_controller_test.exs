defmodule Requestbox.RequestControllerTest do
  use Requestbox.ConnCase
  import Requestbox.Router.TokenHelpers
  alias Requestbox.Repo
  alias Requestbox.Request
  alias Requestbox.Session

  def session do
    case Repo.insert(%Session{}) do
      {:ok, session} -> session
    end
  end

  # test "GET unknown request" do
  #   path = token_request_path(conn(), :capture, 9999)
  #   conn = get(conn(), path)
  #   assert text_response(conn, 404)
  # end

  test "Capture request" do
    session = session()
    IO.inspect(session)
    path = token_request_path(conn(), :capture, session.id)
    conn = conn()
    |> put_req_header("x-header", "value")
    |> get(path)
    request_id = text_response(conn, 200)
    assert request_id
    IO.inspect(request_id)
    request = Repo.get!(Request, request_id)

    assert request.session_id == session.id
    assert request.method == "GET"
    assert request.path == path
    assert request.headers == [%Request.Header{name: "x-header", value: "value"}]
  end
end
