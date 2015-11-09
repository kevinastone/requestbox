defmodule Plug.XForwardedForTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.XForwardedFor

  @opts XForwardedFor.init([])

  test "Extracts X-Forwarded-For" do
    conn = conn(:get, "/hello")
    |> put_req_header("x-forwarded-for", "192.168.100.200")
    conn = XForwardedFor.call(conn, @opts)

    assert conn.remote_ip == {192, 168, 100, 200}
  end

  test "Noop without X-Forwarded-For" do
    conn = conn(:get, "/hello")
    conn = XForwardedFor.call(conn, @opts)

    assert conn.remote_ip == {127, 0, 0, 1}
  end
end
