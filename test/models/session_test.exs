defmodule Requestbox.SessionTest do
  use Requestbox.ModelCase, async: true

  alias Requestbox.Session

  test "changeset without token" do
    changeset = Session.changeset(%Session{}, %{})
    assert(changeset.valid?, inspect(changeset.errors))
  end

  test "changeset with valid token" do
    changeset = Session.changeset(%Session{}, %{token: "abcd"})
    assert(changeset.valid?, inspect(changeset.errors))
  end

  test "changeset with invalid token" do
    changeset = Session.changeset(%Session{}, %{token: "ab"})
    refute changeset.valid?
  end
end
