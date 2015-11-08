defmodule Requestbox.SessionControllerTest do
  use Requestbox.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200)
  end

  test "POST /" do
    conn = post conn(), "/"
    assert html_response(conn, 302)
  end
end
