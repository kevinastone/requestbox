defmodule Requestbox.VanityTest do
  use Requestbox.ModelCase, async: true

  alias Requestbox.Vanity

  test "changeset without name" do
    changeset = Vanity.changeset(%Vanity{}, %{})
    refute changeset.valid?
  end

  test "changeset with name" do
    changeset = Vanity.changeset(%Vanity{}, %{name: "abcd"})
    assert(changeset.valid?, inspect(changeset.errors))
  end

  test "changeset with invalid name" do
    changeset = Vanity.changeset(%Vanity{}, %{name: "something with spaces"})
    refute changeset.valid?
  end

  test "changeset with empty name" do
    changeset = Vanity.changeset(%Vanity{}, %{name: ""})
    refute changeset.valid?
  end
end
