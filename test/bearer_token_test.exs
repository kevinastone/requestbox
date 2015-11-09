defmodule Plug.BearerTokenTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.BearerToken

  @opts BearerToken.init([])

  test "Extracts Bearer Token" do
    conn = conn(:get, "/hello")
    |> put_req_header("authorization", "Bearer abcd")
    conn = BearerToken.call(conn, @opts)

    assert conn.assigns[:token] == "abcd"
  end

  test "Error on Invalid Authorization Header" do
    conn = conn(:get, "/hello")
    |> put_req_header("authorization", "abcd")
    conn = BearerToken.call(conn, @opts)
    assert conn.status == 401
  end

  test "Noop without Bearer Token" do
    conn = conn(:get, "/hello")
    conn = BearerToken.call(conn, @opts)

    refute conn.assigns[:token]
  end
end
