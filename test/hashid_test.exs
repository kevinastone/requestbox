defmodule Requestbox.HashIDTest do
  use ExUnit.Case, async: true

  defmodule TestModule do
    use Requestbox.HashID, salt: "abcd"
  end

  test "encode ID" do
    assert TestModule.encode(1) == "E2"
  end

  test "decode ID" do
    assert TestModule.decode("E2") == 1
  end
end
