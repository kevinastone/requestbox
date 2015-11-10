defmodule Requestbox.HashIDTest do
  use ExUnit.Case

  alias Requestbox.HashID

  test "encode ID" do
    assert HashID.encode(1) == "yQ"
  end

  test "decode ID" do
    assert HashID.decode("yQ") == 1
  end
end
