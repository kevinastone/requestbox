defmodule RequestboxWeb.Schema.HashIDTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  use Requestbox.HashID

  scalar :hashid, name: "HashID" do
    serialize(&encode/1)
    parse(&decode_ast/1)
  end

  defp decode_ast(%Absinthe.Blueprint.Input.String{value: value}) do
    {:ok, decode(value)}
  end
end
