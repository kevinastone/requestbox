defmodule Requestbox.RequestTest do
  use Requestbox.ModelCase, async: true

  alias Requestbox.Request

  @valid_attrs %{body: "some content", headers: [], method: "some content", session_id: "1234", path: "/something"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Request.changeset(%Request{}, @valid_attrs)
    assert(changeset.valid?, inspect(changeset.errors))
  end

  test "changeset with invalid attributes" do
    changeset = Request.changeset(%Request{}, @invalid_attrs)
    refute changeset.valid?
  end
end
