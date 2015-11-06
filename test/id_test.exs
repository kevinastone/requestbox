defmodule Requestbox.IDTest do
  use ExUnit.Case

  alias Requestbox.ID

  test "encode ID" do
    assert ID.encode(1) == "yQ"
  end

  test "decode ID" do
    assert ID.decode("yQ") == 1
  end
end
