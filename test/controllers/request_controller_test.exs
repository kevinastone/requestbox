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

  # test "GET unknown request" do
  #   path = token_request_path(conn(), :capture, 9999)
  #   conn = get(conn(), path)
  #   assert text_response(conn, 404)
  # end

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
