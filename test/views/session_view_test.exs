defmodule Requestbox.RequestViewTest do
  use Requestbox.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "render empty request" do
    request = build(:request)
    render_to_string(Requestbox.SessionView, "request.html", request: request)
  end

  test "render request with headers" do
    request = build(:request)
    |> with_headers(3)
    render_to_string(Requestbox.SessionView, "request.html", request: request)
  end
end
