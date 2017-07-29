defmodule RequestboxWeb.Helpers.HTTPTest do
  use RequestboxWeb.ConnCase, async: true

  alias RequestboxWeb.Helpers.HTTP

  test "Provided Content Type" do
    headers = [%Requestbox.Request.Header{name: "content-type", value: "application/random"}]
    assert HTTP.language_content_type(headers) == "random"
  end

  test "Missing Content Type" do
    headers = [%Requestbox.Request.Header{name: "host", value: "example.com"}]
    assert HTTP.language_content_type(headers, "blah") == "blah"
  end
end
