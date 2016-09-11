defmodule Requestbox.BearerTokenTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Requestbox.BearerToken

  @opts BearerToken.init([])

  test "Extracts Bearer Token" do
    conn = conn(:get, "/hello")
    |> put_req_header("authorization", "Bearer abcd")
    |> BearerToken.call(@opts)

    assert conn.assigns[:token] == "abcd"
  end

  test "Error on Invalid Authorization Header" do
    conn = conn(:get, "/hello")
    |> put_req_header("authorization", "abcd")
    |> BearerToken.call(@opts)
    assert conn.status == 401
  end

  test "Noop without Bearer Token" do
    conn = conn(:get, "/hello")
    |> BearerToken.call(@opts)

    refute conn.assigns[:token]
  end
end
